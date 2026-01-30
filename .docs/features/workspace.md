# Workspace Management

i3 workspace navigation and tmux sessionizer for efficient project switching.

## i3 Workspaces

### Navigation

Vim-style workspace switching using `Ctrl` modifier:

| Key | Workspace |
|-----|-----------|
| `Ctrl+j` | Workspace 1 |
| `Ctrl+k` | Workspace 2 |
| `Ctrl+l` | Workspace 3 |
| `Ctrl+;` | Workspace 4 |

### Move Window to Workspace

Same keys with `Shift` added:

| Key | Action |
|-----|--------|
| `Ctrl+Shift+j` | Move to workspace 1 |
| `Ctrl+Shift+k` | Move to workspace 2 |
| `Ctrl+Shift+l` | Move to workspace 3 |
| `Ctrl+Shift+;` | Move to workspace 4 |

### Workspace Assignment

Default workspace assignments (in i3 config):

| App | Workspace |
|-----|-----------|
| Brave, Firefox | 4 |
| Spotify | (floating) |

### Focus Prevention

Windows cannot steal focus on activation:
```
focus_on_window_activation none
```

New windows flash urgent but don't auto-focus.

## Tmux Sessionizer

Fast project-based tmux session manager. Finds projects and creates/attaches sessions.

### Usage

```bash
tmux-sessionizer        # Interactive project picker
tmux-sessionizer /path  # Jump directly to path
```

Bound to key in shell (typically `Ctrl+f`).

### How It Works

1. Searches configured directories for projects
2. Presents fzf picker
3. Creates new tmux session named after directory
4. Or attaches to existing session

### Configuration

Config file: `~/.config/tmux-sessionizer/tmux-sessionizer.conf`

```bash
# Directories to search (format: "path:depth")
TS_EXTRA_SEARCH_PATHS=(
    "$HOME/Documents:1"
    "$HOME/projects:2"
)

# Patterns to exclude
TS_BLACKLIST=(
    "node_modules"
    ".git"
    "__pycache__"
)
```

### Script Location

Source: `~/.config/tmux-sessionizer/tmux-sessionizer`

Symlinked to: `~/.local/bin/tmux-sessionizer`

## Window Movement Pattern

When opening media or secondary windows, keep them on specific workspace without switching focus:

```bash
xdg-open file.pdf & sleep 0.5 && i3-msg '[title="file.pdf"] move to workspace 5'
```

This:
1. Opens file
2. Waits for window to appear
3. Moves window to target workspace
4. Stays on current workspace

## Scratchpad

i3 scratchpad for temporary floating windows:

| Key | Action |
|-----|--------|
| `Mod+Shift+minus` | Move to scratchpad |
| `Mod+minus` | Show scratchpad |

## Layout Modes

| Key | Layout |
|-----|--------|
| `Mod+s` | Stacking |
| `Mod+w` | Tabbed |
| `Mod+e` | Split toggle |

## Splitting

| Key | Action |
|-----|--------|
| `Mod+h` | Split horizontal |
| `Mod+v` | Split vertical |

## Resizing

Enter resize mode with `Mod+r`, then:

| Key | Action |
|-----|--------|
| `h` or Left | Shrink width |
| `l` or Right | Grow width |
| `k` or Up | Shrink height |
| `j` or Down | Grow height |
| `Escape` | Exit resize mode |
