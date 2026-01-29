#!/bin/bash
#
# Symlink configuration files to expected locations
# Safe to re-run - uses ln -sf (force)
#
set -e

CONFIG_DIR="$HOME/.config"
log() { echo "[$(date +%H:%M:%S)] $*"; }

# Create symlink with backup
# Usage: link_config <source> <target>
_link_config() {
    local src="$1"
    local target="$2"

    if [ ! -e "$src" ]; then
        log "SKIP: Source does not exist: $src"
        return
    fi

    # If target exists and is not a symlink, back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.backup-$(date +%Y%m%d-%H%M%S)"
        log "Backing up existing $target to $backup"
        mv "$target" "$backup"
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"

    ln -sf "$src" "$target"
    log "Linked: $target -> $src"
}

log "Creating symlinks..."

# =============================================================================
# HOME DIRECTORY SYMLINKS
# Files that expect to be in ~ rather than ~/.config
# =============================================================================

rm -f "$HOME/.zshrc"
_link_config "$CONFIG_DIR/zsh/.zshrc" "$HOME/.zshrc"
_link_config "$CONFIG_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
_link_config "$CONFIG_DIR/.xsessionrc" "$HOME/.xsessionrc"

# =============================================================================
# XDG_CONFIG_HOME SYMLINKS
# Most configs are already in ~/.config, no action needed
# These are for configs that might be cloned elsewhere
# =============================================================================

# If repo is cloned somewhere other than ~/.config, uncomment these:
# _link_config "$REPO_DIR/nvim" "$CONFIG_DIR/nvim"
# _link_config "$REPO_DIR/alacritty" "$CONFIG_DIR/alacritty"
# _link_config "$REPO_DIR/i3" "$CONFIG_DIR/i3"
# _link_config "$REPO_DIR/polybar" "$CONFIG_DIR/polybar"
# _link_config "$REPO_DIR/rofi" "$CONFIG_DIR/rofi"
# _link_config "$REPO_DIR/picom" "$CONFIG_DIR/picom"
# _link_config "$REPO_DIR/btop" "$CONFIG_DIR/btop"
# _link_config "$REPO_DIR/kitty" "$CONFIG_DIR/kitty"
# _link_config "$REPO_DIR/lf" "$CONFIG_DIR/lf"
# _link_config "$REPO_DIR/flameshot" "$CONFIG_DIR/flameshot"
# _link_config "$REPO_DIR/pandoc" "$CONFIG_DIR/pandoc"

# =============================================================================
# LOCAL BIN SCRIPTS
# =============================================================================

mkdir -p "$HOME/.local/bin"

# Nerd dictation toggle (if exists)
if [ -f "$CONFIG_DIR/nerd-dictation/nerd-dictation-toggle" ]; then
    _link_config "$CONFIG_DIR/nerd-dictation/nerd-dictation-toggle" "$HOME/.local/bin/nerd-dictation-toggle"
fi

# Theme toggle (gruvbox dark/light)
if [ -f "$CONFIG_DIR/new-machine-setup/toggle-theme" ]; then
    _link_config "$CONFIG_DIR/new-machine-setup/toggle-theme" "$HOME/.local/bin/toggle-theme"
fi

# Focus mode toggle
if [ -f "$CONFIG_DIR/new-machine-setup/focus-toggle" ]; then
    _link_config "$CONFIG_DIR/new-machine-setup/focus-toggle" "$HOME/.local/bin/focus-toggle"
fi

# Screen recording toggle
if [ -f "$CONFIG_DIR/new-machine-setup/screen-record-toggle" ]; then
    _link_config "$CONFIG_DIR/new-machine-setup/screen-record-toggle" "$HOME/.local/bin/screen-record-toggle"
fi

# Lid suspend toggle and sync
if [ -f "$CONFIG_DIR/new-machine-setup/lid-suspend-toggle" ]; then
    _link_config "$CONFIG_DIR/new-machine-setup/lid-suspend-toggle" "$HOME/.local/bin/lid-suspend-toggle"
fi
if [ -f "$CONFIG_DIR/new-machine-setup/lid-suspend-sync" ]; then
    _link_config "$CONFIG_DIR/new-machine-setup/lid-suspend-sync" "$HOME/.local/bin/lid-suspend-sync"
fi

# Backup scripts
if [ -f "$CONFIG_DIR/scripts/backup" ]; then
    _link_config "$CONFIG_DIR/scripts/backup" "$HOME/.local/bin/backup"
fi
if [ -f "$CONFIG_DIR/scripts/backup-repos" ]; then
    _link_config "$CONFIG_DIR/scripts/backup-repos" "$HOME/.local/bin/backup-repos"
fi
if [ -f "$CONFIG_DIR/scripts/backup-bitwarden" ]; then
    _link_config "$CONFIG_DIR/scripts/backup-bitwarden" "$HOME/.local/bin/backup-bitwarden"
fi

# Lock script (kills picom during lock)
if [ -f "$CONFIG_DIR/scripts/lock" ]; then
    _link_config "$CONFIG_DIR/scripts/lock" "$HOME/.local/bin/lock"
fi

# Tmux sessionizer
if [ -f "$CONFIG_DIR/tmux-sessionizer/tmux-sessionizer" ]; then
    _link_config "$CONFIG_DIR/tmux-sessionizer/tmux-sessionizer" "$HOME/.local/bin/tmux-sessionizer"
fi

# Voice dictation (v2 with background transcription)
if [ -f "$CONFIG_DIR/new-machine-setup/voice-dictation" ]; then
    _link_config "$CONFIG_DIR/new-machine-setup/voice-dictation" "$HOME/.local/bin/voice-dictation"
fi
if [ -f "$CONFIG_DIR/new-machine-setup/voice-dictation-transcribe" ]; then
    _link_config "$CONFIG_DIR/new-machine-setup/voice-dictation-transcribe" "$HOME/.local/bin/voice-dictation-transcribe"
fi

# Ralf (ClawdBot CLI wrapper)
if [ -f "$CONFIG_DIR/new-machine-setup/ralf" ]; then
    _link_config "$CONFIG_DIR/new-machine-setup/ralf" "$HOME/.local/bin/ralf"
fi


# =============================================================================
# DESKTOP ENTRIES
# =============================================================================

mkdir -p "$HOME/.local/share/applications"

# Jupyter Lab
if [ -f "$CONFIG_DIR/applications/jupyter-lab.desktop" ]; then
    _link_config "$CONFIG_DIR/applications/jupyter-lab.desktop" "$HOME/.local/share/applications/jupyter-lab.desktop"
fi

log "Symlink creation complete!"
