# Toggle Scripts

System toggle scripts for common features. All follow the same pattern: run once to enable, run again to disable.

## toggle-theme

Switches between dark and light color schemes.

**Location:** `new-machine-setup/toggle-theme`

**Usage:**
```bash
toggle-theme        # Or: Mod+Shift+t
```

**State files:**
- `~/.config/theme-mode` - Current mode (`dark` or `light`)
- `~/.config/theme-schemes` - Scheme names per mode

**Updates:** i3, polybar, alacritty, tmux, GTK, zathura

See [features/theming.md](../features/theming.md) for details.

## focus-toggle

Suppresses desktop notifications for focused work.

**Location:** `new-machine-setup/focus-toggle`

**Usage:**
```bash
focus-toggle        # Or: Mod+Shift+n
```

**Implementation:**
```bash
dunstctl set-paused toggle
```

**Check state:**
```bash
dunstctl is-paused
```

## lid-suspend-toggle

Controls laptop lid close behavior.

**Location:** `new-machine-setup/lid-suspend-toggle`

**Usage:**
```bash
lid-suspend-toggle  # Or: Mod+Shift+a
```

**How it works:**
1. Creates/removes systemd inhibitor
2. Updates polybar icon via IPC

**State:** Managed by systemd-inhibit

**Check state:**
```bash
systemd-inhibit --list | grep lid
```

## lid-suspend-sync

Syncs polybar lid icon with actual system state. Called on startup.

**Location:** `new-machine-setup/lid-suspend-sync`

**Usage:**
```bash
lid-suspend-sync    # Called by i3 startup
```

**Purpose:** Ensures polybar shows correct icon after reboot, regardless of previous state.

## screen-record-toggle

Starts/stops screen recording.

**Location:** `new-machine-setup/screen-record-toggle`

**Usage:**
```bash
screen-record-toggle  # Or: Mod+Shift+c
```

**First press:** Starts FFmpeg recording
**Second press:** Stops recording, saves file

**Output:** `~/Downloads/screenrec_<timestamp>.mp4`

**State file:** `/tmp/screen-record-pid`

**Recording parameters:**
- Format: MP4 (H.264)
- Framerate: 30 fps
- Audio: PulseAudio default source

## Adding New Toggles

Template:

```bash
#!/bin/bash
# my-feature-toggle - Toggle description

STATE_FILE="/tmp/my-feature-state"

if [ -f "$STATE_FILE" ]; then
    # Currently enabled, disable it
    echo "Disabling my-feature"
    # ... disable commands ...
    rm "$STATE_FILE"

    # Optional: Update polybar
    polybar-msg action my-feature hook 0
else
    # Currently disabled, enable it
    echo "Enabling my-feature"
    # ... enable commands ...
    touch "$STATE_FILE"

    # Optional: Update polybar
    polybar-msg action my-feature hook 1
fi
```

Then:
1. Save to `new-machine-setup/my-feature-toggle`
2. `chmod +x new-machine-setup/my-feature-toggle`
3. Add symlink in `link-configs.sh`
4. Add keybinding in `i3/config`
