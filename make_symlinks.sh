#!/bin/bash

# Path to your dotfiles i3 config
DOTFILES_I3_CONFIG="$HOME/dotfiles/i3/config"

# Destination directory for i3 config
I3_CONFIG_DIR="$HOME/.config/i3"

# Destination path for the symlink
I3_CONFIG_LINK="$I3_CONFIG_DIR/config"

# Create the i3 config directory if it doesn't exist
mkdir -p "$I3_CONFIG_DIR"

# Create the symlink, overwriting if it exists
ln -sf "$DOTFILES_I3_CONFIG" "$I3_CONFIG_LINK"

echo "i3 config linked from $DOTFILES_I3_CONFIG to $I3_CONFIG_LINK"

