#!/bin/bash

#to find packages do:
#  grep '^Commandline:' /var/log/apt/history.log 


# Update package index
echo "Updating package index..."
sudo apt update

# Install applications
echo "Installing applications..."

# List of applications to install
apps=(
  git 
  cmake
  tmux
  zsh
  i3
  arandr
  snap
  feh
  picom
  clang
  python3
  polybar
  fzf
  flameshot
)

# Loop through and install each application
for app in "${apps[@]}"; do
    echo "Installing $app..."
    sudo apt install -y "$app"
done

snap_apps=(
  --classic go
  spotify
  alacritty
)

# Loop through and install each application
for app in "${snap_apps[@]}"; do
    echo "Snap installing $app..."
    sudo snap install "$app"
done

echo "All applications installed successfully!"

