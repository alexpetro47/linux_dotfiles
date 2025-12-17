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

_link_config "$CONFIG_DIR/zsh/.zshrc" "$HOME/.zshrc"
_link_config "$CONFIG_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
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
# _link_config "$REPO_DIR/starship" "$CONFIG_DIR/starship"
# _link_config "$REPO_DIR/btop" "$CONFIG_DIR/btop"
# _link_config "$REPO_DIR/kitty" "$CONFIG_DIR/kitty"
# _link_config "$REPO_DIR/lf" "$CONFIG_DIR/lf"
# _link_config "$REPO_DIR/flameshot" "$CONFIG_DIR/flameshot"
# _link_config "$REPO_DIR/pandoc" "$CONFIG_DIR/pandoc"

# =============================================================================
# LOCAL BIN SCRIPTS
# =============================================================================

mkdir -p "$HOME/.local/bin"

# Memory tools
if [ -f "$CONFIG_DIR/memory-tools/m" ]; then
    _link_config "$CONFIG_DIR/memory-tools/m" "$HOME/.local/bin/m"
fi

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

# =============================================================================
# STARSHIP CONFIG
# Starship looks for config in ~/.config/starship.toml by default
# =============================================================================

if [ -f "$CONFIG_DIR/starship/starship.toml" ]; then
    _link_config "$CONFIG_DIR/starship/starship.toml" "$CONFIG_DIR/starship.toml"
fi

log "Symlink creation complete!"
