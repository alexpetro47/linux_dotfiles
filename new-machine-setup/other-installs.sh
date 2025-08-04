
#!/bin/bash

# top portion is commented out as alr used in init-guide
apt_apps=(
  # google-chrome
  # git 
  # cmake
  # zsh
  # tmux
  # alacritty
  # i3
  # polybar
  # rofi
  # feh
  # picom
 
  mintupgrade

  fzf
  fd-find
  ripgrep

  lf
  btop
  ranger
  trash-cli

  flameshot
  simplescreenrecorder
  playerctl
  vlc

  pipes-sh
  cbonsai

  lldb
  clang
  python3
  pylint

  snap
  xclip
  xdotool
)

for app in "${apt_apps[@]}"; do
    echo "Installing $app..."
    sudo apt install -y "$app"
done
