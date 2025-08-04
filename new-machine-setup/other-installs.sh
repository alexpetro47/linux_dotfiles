
#!/bin/bash

# top portion is commented out as alr used in init-guide
# see all installs you've made via `apt-mark showmanual`
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
  nemo
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
  dbeaver
  curl
  zip
  wget
  rclone
  qjackctl
  pipx
  neofetch
  jq
  jupyter
  flatpak
  cloudflared
)

# snap via `snap list`
# gimp
# go
# spotify
# ruff

# pip via pip list
# google-genai
# pydantic
# youtube-transcript-api
# python-dotenv
# websockets

# npm via `npm list -g --depth=0`
# @anthropic-ai/claude-code@1.0.61
# @google/gemini-cli@0.1.14
# @modelcontextprotocol/sdk@1.17.0
# corepack@0.32.0
# markmap-cli@0.18.12
# npm@11.5.1
# plantuml-cli@1.2025.4
# pm2@6.0.8
# repomix@1.2.0
# svg-to-excalidraw@0.0.2
# tsx@4.20.3
# vercel@44.6.6

# cargo via `cargo install --list`
# cargo-tauri

# app images
# cursor
# neo4j

# need to find latex installs as well

for app in "${apt_apps[@]}"; do
    echo "Installing $app..."
    sudo apt install -y "$app"
done
