# Utility Applications

Supporting tools for launching, notifications, PDF viewing, screenshots, and git.

## Rofi

Application launcher and dmenu replacement.

### Config Location

`rofi/config.rasi`

### Usage

| Key | Action |
|-----|--------|
| `Mod+d` | Open launcher |

### Modes

```bash
rofi -show run      # Run commands
rofi -show drun     # Desktop applications
rofi -show window   # Window switcher
rofi -show ssh      # SSH connections
```

### Theming

Rofi can use custom themes. Set in config:

```rasi
@theme "gruvbox-dark"
```

## Dunst

Notification daemon.

### Config Location

`dunst/dunstrc`

### Features

- Notification stacking
- History
- Actions
- Rich formatting

### Commands

```bash
dunstctl close         # Close top notification
dunstctl close-all     # Close all
dunstctl history-pop   # Show last notification
dunstctl set-paused toggle  # Toggle focus mode
```

### Focus Mode

Controlled by `focus-toggle` script. Uses `dunstctl set-paused`.

## Zathura

Vim-like PDF viewer.

### Config Location

`zathura/zathurarc`

### Keybindings

| Key | Action |
|-----|--------|
| `j/k` | Scroll down/up |
| `J/K` | Page down/up |
| `gg` | Go to top |
| `G` | Go to bottom |
| `/` | Search |
| `n/N` | Next/prev search |
| `+/-` | Zoom in/out |
| `=` | Fit width |
| `a` | Fit page |
| `r` | Rotate |
| `q` | Quit |

### Default Application

Set as default PDF viewer:

```bash
xdg-mime default zathura.desktop application/pdf
```

### Theming

Colors managed by tinty. Updates with `toggle-theme`.

## Flameshot

Screenshot tool.

### Usage

| Key | Action |
|-----|--------|
| `Print` | Screenshot GUI |

### Modes

```bash
flameshot gui         # Interactive capture
flameshot full        # Full screen
flameshot screen      # Current monitor
```

### Features

- Region selection
- Annotations (arrows, text, shapes)
- Direct upload
- Clipboard copy
- File save

### Output

Default save location: `~/Pictures/`

## nsxiv

Simple X Image Viewer.

### Config Location

No config file. Options set at runtime.

### Keybindings

| Key | Action |
|-----|--------|
| `n/p` | Next/prev image |
| `+/-` | Zoom |
| `=` | Fit to window |
| `f` | Fullscreen |
| `q` | Quit |

### Default Application

Set as default image viewer:

```bash
xdg-mime default nsxiv.desktop image/jpeg image/png image/gif
```

## Lazygit

Terminal UI for Git.

### Config Location

`lazygit/config.yml` (if exists)

### Usage

```bash
lazygit     # Open in current repo
lg          # Alias
```

### Key Reference

See `lazygit-keys.md` for full keybinding reference.

### Common Operations

| Key | Action |
|-----|--------|
| `Space` | Stage file |
| `c` | Commit |
| `P` | Push |
| `p` | Pull |
| `b` | Branches |
| `s` | Stash |
| `?` | Help |

## lf

Terminal file manager.

### Config Location

`lf/lfrc`

### Usage

```bash
lf          # Open file manager
```

### Navigation

Vim-style (`h`, `j`, `k`, `l`).

## Picom

Compositor for transparency and effects.

### Config Location

`picom/picom.conf`

### Status

Currently disabled (causes idle crashes).

### Features When Enabled

- Window transparency
- Shadows
- Fade animations
- Blur

### Toggle

If needed:

```bash
picom &                    # Start
pkill picom                # Stop
```
