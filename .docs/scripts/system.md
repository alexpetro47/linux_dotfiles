# System Scripts

General system utilities for screen lock, session management, and integrations.

## lock

Screen lock script.

**Location:** `new-machine-setup/scripts/lock`

**Usage:**
```bash
lock
```

**Special handling:**
Kills picom before locking to avoid visual glitches with lock screen:

```bash
pkill picom
i3lock -c 000000  # or other locker
# picom restarted on unlock if it was running
```

## tmux-sessionizer

Fast project-based tmux session manager.

**Location:** `~/.config/tmux-sessionizer/tmux-sessionizer`

**Usage:**
```bash
tmux-sessionizer        # Interactive picker
tmux-sessionizer /path  # Direct jump
```

**How it works:**
1. Searches configured directories for projects
2. Presents fzf picker
3. Creates/attaches tmux session named after directory

**Config:** `~/.config/tmux-sessionizer/tmux-sessionizer.conf`

```bash
# Directories to search (path:depth)
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

See [features/workspace.md](../features/workspace.md) for details.

## ralf

ClawdBot (Ralph) CLI wrapper for messaging the AI agent.

**Location:** `new-machine-setup/ralf`

**Usage:**
```bash
ralf "message"
```

**Purpose:** Quick interaction with ClawdBot from terminal without opening Telegram.

## Common Operations

### Check Running Scripts

```bash
pgrep -a voice-dictation
pgrep -a screen-record
```

### Kill Stuck Scripts

```bash
pkill -f voice-dictation
pkill -f screen-record
```

### Debug Script

Run with bash debug mode:

```bash
bash -x ~/.local/bin/my-script
```

### Check Script Location

```bash
which my-script
readlink -f $(which my-script)
```

## Script Development Tips

### Shebang

Always use:
```bash
#!/bin/bash
```

Or for POSIX:
```bash
#!/bin/sh
```

### Error Handling

```bash
set -e          # Exit on error
set -u          # Exit on undefined variable
set -o pipefail # Exit on pipe failure
```

### Logging

```bash
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}
```

### Notifications

```bash
notify-send "Script Name" "Message"
```

### Polybar Updates

```bash
polybar-msg action module-name hook N
polybar-msg action module-name send "text"
```
