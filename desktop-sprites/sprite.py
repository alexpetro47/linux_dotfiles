#!/usr/bin/env -S uv run --quiet
# /// script
# requires-python = ">=3.10"
# dependencies = ["PySide6"]
# ///
"""
Desktop sprite engine.

Spawns a frameless, transparent, always-on-top character that lives on the edges
of your screen and runs a randomized chain of behaviors: idle, wander, attacks,
hop, somersault, tatsu, shoryuken, hadouken, taunt, moonwalk, dash.

New moves are procedural: physics + rotation applied over the existing frame
sets, so they work for any character without new art.

Edge-relative gravity: the sprite sticks to one screen edge (bottom/top/left/
right). Gravity pulls it onto that surface and it walks *along* the edge, rotated
to stand on it. Drag it anywhere and let go: it snaps to the nearest edge and its
roaming is bounded to the half of the screen you dropped it in.

A "character" is a folder built by build_characters.py:
    characters/<name>/character.json
    characters/<name>/<action>/f_00.png ...

Controls:
    left-drag      move it (release: snaps to nearest edge, bounded to that half)
    right-click    close
    double-click   trigger a random attack

Run:  uv run sprite.py [character] [--edge bottom|top|left|right] [--duration N]
                       [--demo behavior1,behavior2]   (cycle only those behaviors)
"""

import json
import random
import sys
from pathlib import Path

from PySide6.QtCore import Qt, QTimer, QRect, QRectF, QPointF
from PySide6.QtGui import QPainter, QPixmap, QTransform
from PySide6.QtWidgets import QApplication, QWidget

ROOT = Path(__file__).resolve().parent
FPS = 60
DT = 1.0 / FPS

# Physics in screen pixels / seconds. "lift" = distance from the current surface.
GRAVITY = 2200.0
WALK_SPEED = 80.0
HOP_V = 620.0
LAND_LIFT = 140.0  # drop height (logical px) that earns a superhero landing

WIN = 200          # square window: fits the largest frame in any rotation + spin
MARGIN = 60        # keep this far from the perpendicular screen edges

# Rotation (degrees, Qt clockwise) that stands the sprite on each edge.
ORIENT = {"bottom": 0, "top": 180, "left": 90, "right": 270}


class Character:
    def __init__(self, name):
        cdir = ROOT / "characters" / name
        self.manifest = json.loads((cdir / "character.json").read_text())
        self.actions = {}
        for action, meta in self.manifest["actions"].items():
            frames = [QPixmap(str(cdir / action / f"f_{i:02d}.png"))
                      for i in range(meta["frames"])]
            self.actions[action] = {"frames": frames, "fps": meta["fps"],
                                    "loop": meta["loop"]}

    def has(self, action):
        return action in self.actions


class Sprite(QWidget):
    def __init__(self, character, edge="bottom", demo=None):
        super().__init__()
        self.char = character
        self.demo = demo

        self.setWindowFlags(Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
                            | Qt.Tool | Qt.WindowDoesNotAcceptFocus)
        self.setAttribute(Qt.WA_TranslucentBackground)
        self.resize(WIN, WIN)

        self.scr = QApplication.primaryScreen().availableGeometry()

        self.edge = edge
        self.t = 0.0          # tangent position along the edge (x or y)
        self.lift = 0.0       # distance off the surface
        self.vt = 0.0
        self.vlift = 0.0
        self.on_surface = True
        self.facing = 1
        self.t_min, self.t_max = self._full_bounds(edge)
        self.t = (self.t_min + self.t_max) / 2

        self.action = "idle"
        self.frame = 0
        self.frame_t = 0.0
        self.spin_angle = 0.0
        self.spin_rate = 0.0
        self.spinning = False

        self.behavior = "idle"
        self.behavior_t = 0.0
        self.drag_grab = None
        self._mask_rect = None

        self._set_behavior("idle")
        self.timer = QTimer(self)
        self.timer.timeout.connect(self._tick)
        self.timer.start(int(1000 * DT))

    # --- edge geometry ---------------------------------------------------
    def _horizontal(self, edge=None):
        return (edge or self.edge) in ("bottom", "top")

    def _full_bounds(self, edge):
        s = self.scr
        if edge in ("bottom", "top"):
            return s.left() + MARGIN, s.right() - MARGIN
        return s.top() + MARGIN, s.bottom() - MARGIN

    def _surface_point(self):
        """Screen point where the feet sit, given edge / tangent / lift."""
        s = self.scr
        if self.edge == "bottom":
            return QPointF(self.t, s.bottom() - self.lift)
        if self.edge == "top":
            return QPointF(self.t, s.top() + self.lift)
        if self.edge == "left":
            return QPointF(s.left() + self.lift, self.t)
        return QPointF(s.right() - self.lift, self.t)        # right

    # --- behavior chain --------------------------------------------------
    def _action_duration(self, action):
        a = self.char.actions[action]
        return len(a["frames"]) / a["fps"]

    def _set_action(self, action):
        if action != self.action and self.char.has(action):
            self.action, self.frame, self.frame_t = action, 0, 0.0

    def _set_behavior(self, name):
        self.behavior = name
        self.spinning = False
        if name == "idle":
            self.vt = 0.0
            self._set_action("idle")
            self.behavior_t = 0.6 if self.demo else random.uniform(1.4, 3.4)
        elif name == "wander":
            self.facing = random.choice([-1, 1])
            self.vt = self.facing * WALK_SPEED
            self._set_action("walk" if self.char.has("walk") else "idle")
            self.behavior_t = random.uniform(1.6, 4.2)
        elif name == "attack":
            self.vt = 0.0
            choices = [a for a in ("punch", "kick") if self.char.has(a)]
            self._set_action(random.choice(choices) if choices else "idle")
            self.behavior_t = 0.0
        elif name == "hop":
            self.vlift = HOP_V
            self.on_surface = False
            self.vt = random.choice([-1, 1]) * WALK_SPEED * 0.6
            self._set_action("idle")
            self.behavior_t = 0.0
        elif name == "somersault":
            self.facing = random.choice([-1, 1])
            self.on_surface = False
            self.behavior_t = 0.0
            if self.char.has("flip"):
                # real tuck-and-roll frames; arc timed so he lands as it ends
                self._set_action("flip")
                self.vlift = GRAVITY * self._action_duration("flip") / 2
                self.vt = self.facing * WALK_SPEED * 2.2
            else:
                # fallback: rotate the idle frame through the arc; 35% backflip
                v = HOP_V * random.uniform(0.95, 1.2)
                self.vlift = v
                back = random.random() < 0.35
                self.vt = self.facing * WALK_SPEED * (-0.9 if back else 1.7)
                self.spinning, self.spin_angle = True, 0.0
                self.spin_rate = (-360.0 if back else 360.0) * GRAVITY / (2 * v)
                self._set_action("idle")
        elif name == "tatsu":
            # hurricane kick: glide along the edge while the spin plays
            self.facing = random.choice([-1, 1])
            self.vt = self.facing * WALK_SPEED * 2.6
            if self.char.has("tatsu"):
                self._set_action("tatsu")
                self.behavior_t = self._action_duration("tatsu")
            else:
                self._set_action("kick" if self.char.has("kick") else "idle")
                self.behavior_t = random.uniform(0.9, 1.5)
        elif name == "shoryuken":
            self.on_surface = False
            self.vt = self.facing * WALK_SPEED * 0.5
            self.behavior_t = 0.0
            if self.char.has("shoryu"):
                self._set_action("shoryu")
                self.vlift = GRAVITY * self._action_duration("shoryu") / 2
            else:
                self._set_action("punch" if self.char.has("punch") else "idle")
                self.vlift = HOP_V * 1.25
        elif name in ("hadouken", "taunt", "win", "land"):
            self.vt = 0.0
            self._set_action(name)
            self.behavior_t = 0.0
        elif name == "fall":
            self.vt = 0.0
            self._set_action("idle")
            self.behavior_t = 0.0
        elif name == "moonwalk":
            self.facing = random.choice([-1, 1])
            self.vt = -self.facing * WALK_SPEED * 0.75
            self._set_action("walk" if self.char.has("walk") else "idle")
            self.behavior_t = random.uniform(1.5, 3.0)
        elif name == "dash":
            self.facing = random.choice([-1, 1])
            self.vt = self.facing * WALK_SPEED * 3.4
            if self.char.has("dashf"):
                self._set_action("dashf")
                self.behavior_t = self._action_duration("dashf")
            else:
                # static forward lean (spin machinery with rate 0)
                self.spinning, self.spin_angle, self.spin_rate = True, 14.0, 0.0
                self._set_action("walk" if self.char.has("walk") else "idle")
                self.behavior_t = random.uniform(0.5, 0.9)

    def _next_behavior(self):
        w = {"idle": 3.0, "wander": 4.0, "hop": 1.0,
             "moonwalk": 1.0, "dash": 1.0,
             "somersault": 0.35}          # big jump: kept rare
        if any(self.char.has(a) for a in ("punch", "kick")):
            w["attack"] = 1.5
        if self.char.has("tatsu") or self.char.has("kick"):
            w["tatsu"] = 0.35
        if self.char.has("shoryu") or self.char.has("punch"):
            w["shoryuken"] = 0.25         # big jump too
        if self.char.has("hadouken"):
            w["hadouken"] = 0.35
        if self.char.has("taunt"):
            w["taunt"] = 0.6
        if self.char.has("win"):
            w["win"] = 0.6
        if self.demo:
            w = {b: 1.0 for b in self.demo}
        names = list(w)
        self._set_behavior(random.choices(names, [w[n] for n in names])[0])

    # --- main loop -------------------------------------------------------
    def _tick(self):
        self._advance_animation()
        if self.drag_grab is None:
            self._advance_behavior()
            self._advance_physics()
            self._place()          # while dragging, the mouse handler owns position
        self.update()

    def _advance_animation(self):
        a = self.char.actions[self.action]
        self.frame_t += DT
        step = 1.0 / a["fps"]
        while self.frame_t >= step:
            self.frame_t -= step
            self.frame += 1
            if self.frame >= len(a["frames"]):
                self.frame = 0 if a["loop"] else len(a["frames"]) - 1

    def _action_finished(self):
        a = self.char.actions[self.action]
        return (not a["loop"]) and self.frame >= len(a["frames"]) - 1

    def _advance_behavior(self):
        if self.spinning:
            self.spin_angle += self.spin_rate * DT
        if self.behavior in ("attack", "hadouken", "taunt", "win", "land"):
            if self._action_finished():
                self._set_behavior("idle")
            return
        if self.behavior == "fall":
            if self.on_surface:
                self._set_behavior("land")
            return
        if self.behavior in ("hop", "somersault", "shoryuken"):
            if self.on_surface:
                self._set_behavior("idle")
            return
        if self.behavior == "tatsu" and self.action == "kick" \
                and self._action_finished():
            self.frame, self.frame_t = 0, 0.0     # fallback: re-fire the kick
        self.behavior_t -= DT
        if self.behavior_t <= 0:
            self._next_behavior()

    def _advance_physics(self):
        # gravity pulls toward the surface (lift -> 0)
        if not self.on_surface:
            self.vlift -= GRAVITY * DT
            self.lift += self.vlift * DT
            if self.lift <= 0:
                self.lift, self.vlift, self.on_surface = 0.0, 0.0, True

        # tangent motion + bounded turn-around
        if self.vt:
            self.t += self.vt * DT
            if self.t <= self.t_min:
                self.t, self.facing, self.vt = self.t_min, 1, abs(self.vt)
            elif self.t >= self.t_max:
                self.t, self.facing, self.vt = self.t_max, -1, -abs(self.vt)
            if self.behavior == "wander":
                self.facing = 1 if self.vt > 0 else -1

    def _place(self):
        h = self.char.actions[self.action]["frames"][self.frame].height()
        feet = QTransform().rotate(ORIENT[self.edge]).map(QPointF(0, h / 2))
        s = self._surface_point()
        self.move(round(s.x() - WIN / 2 - feet.x()),
                  round(s.y() - WIN / 2 - feet.y()))

    # --- painting --------------------------------------------------------
    def paintEvent(self, _event):
        pm = self.char.actions[self.action]["frames"][self.frame]
        w, h = pm.width(), pm.height()

        p = QPainter(self)
        p.setRenderHint(QPainter.SmoothPixmapTransform)
        p.translate(WIN / 2, WIN / 2)
        angle = ORIENT[self.edge] + (self.spin_angle if self.spinning else 0)
        p.rotate(angle)
        if self.facing < 0:
            p.scale(-1, 1)
        p.drawPixmap(int(-w / 2), int(-h / 2), pm)
        p.end()

        # clickable region = rotated bounding box of the frame (rest passes through)
        if self.spinning:
            rect = QRect(0, 0, WIN, WIN)
        else:
            t = QTransform().translate(WIN / 2, WIN / 2).rotate(ORIENT[self.edge])
            rect = t.mapRect(QRectF(-w / 2, -h / 2, w, h)).toRect()
            rect = rect.adjusted(-3, -3, 3, 3)
        if rect != self._mask_rect:
            self._mask_rect = rect
            self.setMask(rect)

    # --- interaction -----------------------------------------------------
    def mousePressEvent(self, event):
        if event.button() == Qt.LeftButton:
            self.drag_grab = event.globalPosition().toPoint() - self.pos()
            self._set_action("idle")
            self.vt = self.vlift = 0.0
        elif event.button() == Qt.RightButton:
            self.close()

    def mouseMoveEvent(self, event):
        if self.drag_grab is not None:
            self.move(event.globalPosition().toPoint() - self.drag_grab)

    def mouseReleaseEvent(self, _event):
        if self.drag_grab is None:
            return
        self.drag_grab = None
        self._snap_to_nearest_edge()
        if (not self.on_surface and self.lift > LAND_LIFT
                and self.char.has("land")):
            self._set_behavior("fall")
        else:
            self._set_behavior("idle")

    def _snap_to_nearest_edge(self):
        s = self.scr
        cx, cy = self.x() + WIN / 2, self.y() + WIN / 2
        dist = {"bottom": s.bottom() - cy, "top": cy - s.top(),
                "left": cx - s.left(), "right": s.right() - cx}
        self.edge = min(dist, key=dist.get)

        lo, hi = self._full_bounds(self.edge)
        if self._horizontal():
            mid = s.center().x()
            self.t_min, self.t_max = (lo, mid) if cx < mid else (mid, hi)
            self.t = min(max(cx, self.t_min), self.t_max)
            self.lift = max(0.0, (s.bottom() - cy) if self.edge == "bottom"
                            else (cy - s.top()))
        else:
            mid = s.center().y()
            self.t_min, self.t_max = (lo, mid) if cy < mid else (mid, hi)
            self.t = min(max(cy, self.t_min), self.t_max)
            self.lift = max(0.0, (cx - s.left()) if self.edge == "left"
                            else (s.right() - cx))
        self.vt = self.vlift = 0.0
        self.on_surface = self.lift <= 1.0

    def mouseDoubleClickEvent(self, _event):
        if any(self.char.has(a) for a in ("punch", "kick")):
            self._set_behavior("attack")

    def keyPressEvent(self, event):
        if event.key() == Qt.Key_Escape:
            self.close()


def main():
    argv = sys.argv[1:]
    vals = {argv[i + 1] for i, a in enumerate(argv)
            if a in ("--edge", "--duration", "--demo") and i + 1 < len(argv)}
    pos = [a for a in argv if not a.startswith("-") and a not in vals]
    name = pos[0] if pos else "ryu"
    edge = "bottom"
    if "--edge" in sys.argv:
        edge = sys.argv[sys.argv.index("--edge") + 1]
    demo = None
    if "--demo" in sys.argv:
        demo = sys.argv[sys.argv.index("--demo") + 1].split(",")

    app = QApplication(sys.argv)
    app.setApplicationName("desktop-sprite")
    app.setDesktopFileName("desktop-sprite")

    sprite = Sprite(Character(name), edge=edge, demo=demo)
    sprite.show()

    if "--duration" in sys.argv:
        secs = float(sys.argv[sys.argv.index("--duration") + 1])
        QTimer.singleShot(int(secs * 1000), app.quit)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
