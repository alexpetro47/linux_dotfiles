#!/usr/bin/env -S uv run --quiet
# /// script
# requires-python = ">=3.10"
# dependencies = ["pillow"]
# ///
"""
Build normalized character folders from raw candidate GIFs.

Source sprite rips come at wildly different scales (e.g. Ryu's SF3 stand is
~520px tall, his SF2 walk is ~106px). For a coherent on-screen character every
action must render the standing figure at the same height, with feet planted.

For each action this:
  1. coalesces the GIF into RGBA frames,
  2. crops every frame to the action's *union* alpha bounding box (keeps frames
     aligned within the action, drops dead margin),
  3. scales by a per-action factor so the neutral (frame 0) figure is BODY_H tall,
  4. writes f_NN.png plus a character.json manifest the engine reads.

Anchor is bottom-center: scaling and action changes keep the feet on one ground line.

Run:  uv run build_characters.py
"""

import json
from pathlib import Path

from PIL import Image, ImageSequence

ROOT = Path(__file__).resolve().parent
SRC = ROOT / "candidates" / "streetfighter"
BODY_H = 96  # target height (px) of the neutral standing figure

# character -> {action: (source_gif, fps, loops?[, anchor[, scale_ref[, frames]]])}
#   frames: list of source frame indices (repeats allowed) to slice/reorder a
#     gif, e.g. hold a pose by repeating its index.
#   anchor "union" (default): crop all frames to the shared alpha bbox -- keeps
#     in-canvas motion (e.g. a projectile flying off).
#   anchor "frame": crop each frame to its own bbox, bottom-centered -- strips
#     travel/arc baked into the gif so the engine's physics supply all motion.
#   scale_ref: gif whose frame-0 standing figure defines the scale (for rips
#     whose own frame 0 isn't a neutral stand).
# New gifs ripped from fightersgeneration.com Ryu pages (characters3/ryu-a*.html;
# ryu-cfe-jump2 from np7/char/gifs/ryu/). ry-s4.gif is the SF3 stance, used as
# the scale reference for the SF3-native rips. NOTE: justnopoint.com/zweifuss
# hosts the same rips but with corrupted palettes -- don't use that mirror.
CHARACTERS = {
    "ryu": {
        "idle":  ("ryustand.gif", 12, True),
        "walk":  ("ryu-walk.gif", 14, True),
        "punch": ("ryupunch.gif", 18, False),
        "kick":  ("ryukick.gif", 14, False),
        "flip":     ("ryu-cfe-jump2.gif", 40, False, "frame"),
        "tatsu":    ("ryu-hurricane-ts.gif", 17, False, "frame", "ry-s4.gif"),
        "shoryu":   ("ryu-shoryukens.gif", 24, False, "frame", "ry-s4.gif"),
        "hadouken": ("ryu-fireballs.gif", 14, False, "union", "ry-s4.gif"),
        "taunt":    ("ryu-ts-taunt1.gif", 12, False, "union", "ry-s4.gif"),
        "dashf":    ("ryu-dashf.gif", 14, False, "frame", "ry-s4.gif"),
        # superhero landing: shoryuken windup crouch held, then the rise frame
        "land":     ("ryu-shoryukens.gif", 10, False, "frame", "ry-s4.gif",
                     [0, 0, 0, 0, 0, 0, 0, 1]),
    },
}


def load_frames(gif_path):
    """Coalesced list of RGBA frames (frame disposal already applied by Pillow)."""
    im = Image.open(gif_path)
    return [f.convert("RGBA") for f in ImageSequence.Iterator(im)]


def union_bbox(frames):
    box = None
    for f in frames:
        b = f.getbbox()  # bbox of non-zero (incl. alpha) region
        if b is None:
            continue
        if box is None:
            box = list(b)
        else:
            box[0] = min(box[0], b[0])
            box[1] = min(box[1], b[1])
            box[2] = max(box[2], b[2])
            box[3] = max(box[3], b[3])
    return tuple(box) if box else None


def build_action(frames, scale, anchor="union"):
    box = union_bbox(frames)
    out = []
    for f in frames:
        b = f.getbbox() if anchor == "frame" else box
        c = f.crop(b or box)
        w = max(1, round(c.width * scale))
        h = max(1, round(c.height * scale))
        out.append(c.resize((w, h), Image.LANCZOS))
    return out


def main():
    manifest_root = {}
    for char, actions in CHARACTERS.items():
        cdir = ROOT / "characters" / char
        manifest = {"name": char, "body_height": BODY_H, "actions": {}}

        # scale factor per action keyed off frame-0 neutral-stance height
        for action, spec in actions.items():
            gif, fps, loop = spec[:3]
            anchor = spec[3] if len(spec) > 3 else "union"
            scale_ref = spec[4] if len(spec) > 4 else gif
            frames = load_frames(SRC / gif)
            if len(spec) > 5:
                frames = [frames[i] for i in spec[5]]
            ref0 = load_frames(SRC / scale_ref)[0]
            f0_box = ref0.getbbox()
            f0_h = (f0_box[3] - f0_box[1]) if f0_box else ref0.height
            scale = BODY_H / f0_h
            built = build_action(frames, scale, anchor)

            adir = cdir / action
            adir.mkdir(parents=True, exist_ok=True)
            for p in adir.glob("*.png"):
                p.unlink()
            for i, im in enumerate(built):
                im.save(adir / f"f_{i:02d}.png")

            manifest["actions"][action] = {
                "frames": len(built),
                "fps": fps,
                "loop": loop,
                "size": [built[0].width, built[0].height],
            }
            print(f"{char}/{action}: {len(built)} frames, scale {scale:.3f}, "
                  f"frame size {built[0].width}x{built[0].height}")

        (cdir / "character.json").write_text(json.dumps(manifest, indent=2))
        manifest_root[char] = str(cdir)
        print(f"  -> wrote {cdir / 'character.json'}")


if __name__ == "__main__":
    main()
