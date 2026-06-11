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

# character -> {action: (source_gif, fps, loops?)}
CHARACTERS = {
    "ryu": {
        "idle":  ("ryustand.gif", 12, True),
        "walk":  ("ryu-walk.gif", 14, True),
        "punch": ("ryupunch.gif", 18, False),
        "kick":  ("ryukick.gif", 14, False),
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


def build_action(frames, scale):
    box = union_bbox(frames)
    out = []
    for f in frames:
        c = f.crop(box)
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
        for action, (gif, fps, loop) in actions.items():
            frames = load_frames(SRC / gif)
            f0_box = frames[0].getbbox()
            f0_h = (f0_box[3] - f0_box[1]) if f0_box else frames[0].height
            scale = BODY_H / f0_h
            built = build_action(frames, scale)

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
