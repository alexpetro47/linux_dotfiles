# Polybar

Status bar with system monitors, IPC-enabled modules for toggles, and tinty theming integration.

## Config Location

- Main: `polybar/config.ini`
- Colors: `polybar/colors.ini` (tinty-managed)

## Modules

### System Monitors

| Module | Information |
|--------|-------------|
| `cpu` | CPU usage percentage |
| `memory` | RAM usage |
| `battery` | Charge level, charging state |
| `wlan` | WiFi connection status |
| `pulseaudio` | Volume level |
| `date` | Date and time |

### IPC Modules

These modules update via IPC messages for toggle status:

| Module | Purpose |
|--------|---------|
| `voice-dictation` | Recording/transcribing status |
| `lid-suspend` | Lid behavior indicator |

### Workspaces

```ini
[module/i3]
type = internal/i3
```

Shows i3 workspace indicators.

## IPC Commands

Control modules via `polybar-msg`:

```bash
# Toggle bar visibility
polybar-msg cmd toggle

# Restart bar
polybar-msg cmd restart

# Send action to module
polybar-msg action voice-dictation send "recording"
polybar-msg action lid-suspend send "active"
```

## Colors

Colors defined in `colors.ini` and updated by tinty:

```ini
[colors]
background = ${xrdb:color0:#1d2021}
foreground = ${xrdb:color7:#ebdbb2}
primary = ${xrdb:color4:#458588}
secondary = ${xrdb:color2:#98971a}
alert = ${xrdb:color1:#cc241d}
```

## Bar Configuration

```ini
[bar/main]
width = 100%
height = 32
background = ${colors.background}
foreground = ${colors.foreground}
font-0 = JetBrainsMono Nerd Font:size=12;2
modules-left = i3
modules-center = date
modules-right = voice-dictation lid-suspend cpu memory pulseaudio wlan battery
```

## Starting Polybar

Started by i3 config:

```
exec_always --no-startup-id polybar main
```

Or manually:

```bash
polybar main &
```

## Custom Modules

### Script Module

```ini
[module/my-script]
type = custom/script
exec = ~/scripts/my-status.sh
interval = 5
```

### IPC Module

```ini
[module/my-toggle]
type = custom/ipc
hook-0 = echo "off"
hook-1 = echo "on"
initial = 1
```

Control with:
```bash
polybar-msg action my-toggle hook 0  # Set to "off"
polybar-msg action my-toggle hook 1  # Set to "on"
```

## Troubleshooting

**Bar not appearing:**
```bash
polybar main 2>&1 | head -20  # Check for errors
```

**Colors not updating:**
```bash
polybar-msg cmd restart
```

**Module not updating:**
```bash
# For script modules
polybar-msg action module-name hook 0
```

**Check running bars:**
```bash
pgrep -a polybar
```

## Adding New Modules

1. Define module in `config.ini`:
   ```ini
   [module/new-module]
   type = custom/script
   exec = ~/scripts/new-status.sh
   interval = 10
   ```

2. Add to bar:
   ```ini
   modules-right = ... new-module ...
   ```

3. Restart polybar:
   ```bash
   polybar-msg cmd restart
   ```
