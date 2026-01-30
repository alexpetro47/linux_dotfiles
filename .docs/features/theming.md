# Theming

Centralized color management using tinty and base16 color schemes. A single toggle command updates all themed applications simultaneously.

## Quick Usage

```bash
# Toggle dark/light
toggle-theme              # Or: Mod+Shift+t

# Apply specific scheme
tinty apply gruvbox-dark-medium
tinty apply catppuccin-mocha

# Find schemes
tinty list | grep nord
tinty list | grep gruvbox
```

## How It Works

### Tinty

[Tinty](https://github.com/tinted-theming/tinty) is a base16/base24 color scheme manager. It:

1. Maintains scheme templates for each application
2. Applies schemes by generating config files from templates
3. Triggers reload hooks for live updates

### Toggle-Theme Script

`new-machine-setup/toggle-theme` switches between configured dark and light schemes:

1. Reads current mode from `~/.config/theme-mode`
2. Looks up scheme name in `~/.config/theme-schemes`
3. Runs `tinty apply <scheme>`
4. Writes new mode to state file

### Configuration Files

| File | Purpose |
|------|---------|
| `~/.config/theme-mode` | Current mode: `dark` or `light` |
| `~/.config/theme-schemes` | Scheme names for each mode |

`~/.config/theme-schemes` format:
```
dark=gruvbox-dark-medium
light=gruvbox-light-medium
```

## Themed Applications

| Application | Config Location | Reload Method |
|-------------|-----------------|---------------|
| i3 | `~/.config/i3/config` | `i3-msg reload` |
| Polybar | `~/.config/polybar/colors.ini` | `polybar-msg cmd restart` |
| Alacritty | `~/.config/alacritty/colors.toml` | Auto-reload |
| Tmux | `~/.config/tmux/colors.conf` | `tmux source` |
| GTK 3 | `~/.config/gtk-3.0/settings.ini` | Next app launch |
| Zathura | `~/.config/zathura/zathurarc` | Next launch |

## Adding New Applications

1. Create tinty template in `~/.config/tinted-theming/tinty/templates/`
2. Register in tinty config
3. Add reload hook if needed

See [tinty documentation](https://github.com/tinted-theming/tinty) for template format.

## Default Schemes

| Mode | Scheme |
|------|--------|
| Dark | `gruvbox-dark-medium` |
| Light | `gruvbox-light-medium` |

## Base16 Color Slots

Standard base16 colors used across themes:

| Slot | Typical Use |
|------|-------------|
| base00 | Background |
| base01 | Lighter background |
| base02 | Selection |
| base03 | Comments |
| base04 | Dark foreground |
| base05 | Foreground |
| base06 | Light foreground |
| base07 | Lightest foreground |
| base08 | Red (errors) |
| base09 | Orange (warnings) |
| base0A | Yellow (modified) |
| base0B | Green (strings) |
| base0C | Cyan (support) |
| base0D | Blue (functions) |
| base0E | Purple (keywords) |
| base0F | Brown (deprecated) |

## Troubleshooting

**Theme doesn't apply to GTK apps:**
GTK apps read theme on launch. Restart the application.

**Polybar colors wrong:**
```bash
polybar-msg cmd restart
```

**tmux colors wrong:**
```bash
tmux source ~/.tmux.conf
```

**Check current scheme:**
```bash
tinty current
```
