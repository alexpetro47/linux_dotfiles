
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

# need to find latex installs as well

for app in "${apt_apps[@]}"; do
    echo "Installing $app..."
    sudo apt install -y "$app"
done
