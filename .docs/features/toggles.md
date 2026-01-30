# System Toggles

Quick keyboard toggles for common system behaviors. All toggles are bound to `Mod+Shift+<key>` combinations.

## Toggle Summary

| Key | Toggle | Script |
|-----|--------|--------|
| `Mod+Shift+t` | Theme (dark/light) | `toggle-theme` |
| `Mod+Shift+n` | Focus mode (notifications) | `focus-toggle` |
| `Mod+Shift+b` | Polybar visibility | i3 config |
| `Mod+Shift+c` | Screen recording | `screen-record-toggle` |
| `Mod+Shift+a` | Lid suspend | `lid-suspend-toggle` |

## Focus Toggle

Suppresses desktop notifications for distraction-free work.

**Script:** `new-machine-setup/focus-toggle`

**How it works:**
1. Uses `dunstctl` to pause/resume notifications
2. Stores state for persistence

**State file:** None (dunst manages its own state)

**Commands:**
```bash
focus-toggle        # Toggle on/off
dunstctl is-paused  # Check current state
```

## Lid Suspend Toggle

Controls whether closing the laptop lid suspends the system.

**Script:** `new-machine-setup/lid-suspend-toggle`

**How it works:**
1. Creates/removes inhibit file
2. systemd-logind checks for inhibit before suspending
3. Updates polybar icon via IPC

**Visual feedback:** Polybar shows lid icon state

**Sync script:** `lid-suspend-sync` - Called on startup to sync polybar icon with actual system state

**Commands:**
```bash
lid-suspend-toggle  # Toggle behavior
systemd-inhibit --list  # Check active inhibitors
```

## Screen Recording Toggle

Starts/stops screen recording using FFmpeg.

**Script:** `new-machine-setup/screen-record-toggle`

**How it works:**
1. First press: Starts FFmpeg recording
2. Second press: Stops recording
3. Saves to `~/Downloads/screenrec_<timestamp>.mp4`

**Recording settings:**
- Format: MP4 (H.264)
- Framerate: 30 fps
- Audio: PulseAudio capture

**State file:** `/tmp/screen-record-pid`

**Commands:**
```bash
screen-record-toggle  # Start/stop
ls ~/Downloads/screenrec_*.mp4  # Find recordings
```

## Polybar Toggle

Hides/shows the polybar status bar.

**Implementation:** Direct i3 config (not a script)

**i3 config binding:**
```
bindsym $mod+Shift+b exec --no-startup-id polybar-msg cmd toggle
```

## Theme Toggle

See [theming.md](theming.md) for full documentation.

**Script:** `new-machine-setup/toggle-theme`

**Quick usage:**
```bash
toggle-theme  # Switch dark/light
```

## Adding New Toggles

1. Create toggle script in `new-machine-setup/`
2. Add symlink in `link-configs.sh`
3. Add keybinding in `i3/config`
4. (Optional) Add polybar module for status

Template structure:
```bash
#!/bin/bash
STATE_FILE="/tmp/my-toggle-state"

if [ -f "$STATE_FILE" ]; then
    # Currently on, turn off
    # ... disable action ...
    rm "$STATE_FILE"
else
    # Currently off, turn on
    # ... enable action ...
    touch "$STATE_FILE"
fi
```
