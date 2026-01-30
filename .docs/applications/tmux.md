# Tmux

Terminal multiplexer configuration with vim-style navigation, TPM plugin manager, and theming integration.

## Config Location

- Source: `tmux/tmux.conf`
- Symlink: `~/.tmux.conf`
- Colors: `tmux/colors.conf` (tinty-managed)

## Prefix Key

```
set -g prefix C-w  # Ctrl+w
unbind C-b
```

## Keybindings

### Pane Management

| Key | Action |
|-----|--------|
| `Prefix + \|` | Split vertical |
| `Prefix + -` | Split horizontal |
| `Prefix + h` | Focus left |
| `Prefix + j` | Focus down |
| `Prefix + k` | Focus up |
| `Prefix + l` | Focus right |
| `Prefix + x` | Close pane |

### Window Management

| Key | Action |
|-----|--------|
| `Prefix + c` | New window |
| `Prefix + n` | Next window |
| `Prefix + p` | Previous window |
| `Prefix + 0-9` | Go to window |
| `Prefix + ,` | Rename window |

### Session Management

| Key | Action |
|-----|--------|
| `Prefix + d` | Detach |
| `Prefix + s` | List sessions |
| `Prefix + $` | Rename session |

### Copy Mode

| Key | Action |
|-----|--------|
| `Prefix + [` | Enter copy mode |
| `v` | Start selection (in copy mode) |
| `y` | Yank selection |
| `q` | Exit copy mode |

### Plugins

| Key | Action |
|-----|--------|
| `Prefix + I` | Install plugins |
| `Prefix + U` | Update plugins |

## Plugin Manager (TPM)

[TPM](https://github.com/tmux-plugins/tpm) manages plugins.

Install plugins:
```
Prefix + I
```

### Installed Plugins

| Plugin | Purpose |
|--------|---------|
| `tmux-sensible` | Sensible defaults |
| `tmux-yank` | System clipboard |
| `tmux-resurrect` | Session persistence |
| `tmux-continuum` | Auto-save sessions |

## Status Line

```
set -g status-position bottom
set -g status-left '[#S] '
set -g status-right ' #(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD 2>/dev/null) | %H:%M '
```

Shows:
- Session name (left)
- Git branch (right)
- Time (right)

## Colors

Sourced from tinty-managed file:

```
source-file ~/.config/tmux/colors.conf
```

Colors update with `toggle-theme`.

## Mouse Support

```
set -g mouse on
```

Enables:
- Pane selection
- Window switching
- Scrolling
- Resizing

## True Color

```
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*256col*:Tc"
```

## Session Persistence

With tmux-resurrect and tmux-continuum:

- Sessions auto-saved every 15 minutes
- Restore last session on tmux start
- `Prefix + Ctrl-s` to save manually
- `Prefix + Ctrl-r` to restore manually

## Common Commands

```bash
tmux                    # Start/attach
tmux new -s name        # New named session
tmux attach -t name     # Attach to session
tmux ls                 # List sessions
tmux kill-session -t n  # Kill session
```

## Tmux Sessionizer Integration

See [features/workspace.md](../features/workspace.md) for tmux-sessionizer project manager.

## Adding Keybindings

Add to `tmux/tmux.conf`:

```bash
bind key command
```

Then reload:

```bash
tmux source ~/.tmux.conf
# or: Prefix + :source ~/.tmux.conf
```
