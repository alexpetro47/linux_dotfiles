#!/bin/bash

# manual install: reaper, 

echo "Welcome to my installation script..."

while true; do
  read -n 1 -p "Continue? (y/n): " answer
  case $answer in
    [Yy]* ) echo "Continuing..."; break;;
    [Nn]* ) echo "Exiting..."; exit;;
    * ) echo "  Please answer y or n.";;
  esac
done

# Update package index
echo "Updating package index..."
sudo apt update

# Install applications
echo "Installing applications..."

List of applications to install
apps=(
  git 
  cmake
  tmux
  zsh
  i3
  arandr
  snap
  feh
  xcompmgr
  clang
  python3
  polybar
  fzf
  flameshot
  rofi
  playerctl
  ripgrep
  lldb
  xclip
  cbonsai
  kdeconnect
  fd-find
  mintupgrade
  btop
  lf
  trash-cli
  ranger # use this for its "rifle" opener package
  xdotool
  vlc
  pylint
  pipes-sh
  shotcut
  simplescreenrecorder
)

snap_apps=(
  --classic go
  # --classic obsidian
  # spotify
  alacritty
)

# flatpak??
# ---
# sudo add-apt-repository ppa:flatpak/stable -y
# sudo apt update
# sudo apt install flatpak
# 
# sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# ---
# flatpak install flathub com.boxy_svg.BoxySVG
# # run with `flatpak run com.boxy_svg.BoxySVG`
# ---

# npm ??
# npm install -g
# @anthropic-ai/claude-code
# repomix
# markmap-cli
# mdpdf
# n8n


for app in "${apps[@]}"; do
    echo "Installing $app..."
    sudo apt install -y "$app"
done

for app in "${snap_apps[@]}"; do
    echo "Snap installing $app..."
    sudo snap install "$app"
done



echo "Neovim, built from source, next up"
while true; do
    read -n 1 -p "Continue? (y/n): " answer
    case $answer in
        [Yy]* ) echo "Continuing..."; break;;
        [Nn]* ) echo "Exiting..."; exit;;
        * ) echo "  Please answer y or n.";;
    esac
done


cd ~
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo 
sudo make install


echo "Clone github dotfiles into ~/.config ..."
while true; do
    read -n 1 -p "Continue? (y/n): " answer
    case $answer in
        [Yy]* ) echo "Continuing..."; break;;
        [Nn]* ) echo "Exiting..."; exit;;
        * ) echo "  Please answer y or n.";;
    esac
done

echo "cloning from my github dotfiles (linux) into ~/temp_dotfiles"
git clone https://github.com/justatoaster47/linux_dotfiles.git ~/temp_dotfiles
cp -r ~/temp_dotfiles/* ~/.config/



echo "Install JetBrains Mono Nerd Font.. "
while true; do
    read -n 1 -p "Continue? (y/n): " answer
    case $answer in
        [Yy]* ) echo "Continuing..."; break;;
        [Nn]* ) echo "Exiting..."; exit;;
        * ) echo "  Please answer y or n.";;
    esac
done

mkdir -p ~/.local/share/fonts
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip && \
unzip JetBrainsMono.zip -d ~/.local/share/fonts/ && \
rm JetBrainsMono.zip
fc-cache -fv


echo "Use xmodmap to set keybinds.. "
while true; do
    read -n 1 -p "Continue? (y/n): " answer
    case $answer in
        [Yy]* ) echo "Continuing..."; break;;
        [Nn]* ) echo "Exiting..."; exit;;
        * ) echo "  Please answer y or n.";;
    esac
done

ln -s ~/.config/.Xmodmap ~/.Xmodmap




echo "Configure zsh as shell.. "
while true; do
    read -n 1 -p "Continue? (y/n): " answer
    case $answer in
        [Yy]* ) echo "Continuing..."; break;;
        [Nn]* ) echo "Exiting..."; exit;;
        * ) echo "  Please answer y or n.";;
    esac
done

zsh

echo "installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git_clones=(
  https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
  https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
  --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
)

echo "doing git clones for autosuggestions, syntax highlighting, and p10k"
for repo in "${git_clones[@]}"; do
  git clone $repo
done

echo "linking zsh and p10k from config to ~/"
rm ~/.zshrc
rm ~/.p10k.zsh
ln -s ~/.config/zsh/.zshrc ~/.zshrc
ln -s ~/.config/zsh/.p10k.zsh ~/.p10k.zsh
source ~/.zshrc

echo "linking aider conf from config to ~/"
rm ~/.aider.conf.yml
ln -s ~/.config/aider/.aider.conf.yml ~/.aider.conf.yml 

echo "changing default shell to zsh"
chsh -s $(which zsh)
source ~/.zshrc


# echo "Configure screen layouts (laptop, external, both).. "
# while true; do
#     read -n 1 -p "Continue? (y/n): " answer
#     case $answer in
#         [Yy]* ) echo "Continuing..."; break;;
#         [Nn]* ) echo "Exiting..."; exit;;
#         * ) echo "  Please answer y or n.";;
#     esac
# done

# echo "configuring screen layouts"
# mkdir ~/.screenlayouts
# cp * ~/.config/screenlayouts ~/.screenlayouts
# chmod +x ~/.screenlayouts/*

# # install chrome for keychron config
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo dpkg -i google-chrome-stable_current_amd64.deb
# sudo apt-get install -f                                                       
# # the following is occasionally hidraw3 or 1
# sudo chmod a+rw /dev/hidraw2  
