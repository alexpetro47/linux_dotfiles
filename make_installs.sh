#!/bin/bash

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
  picom
  clang
  python3
  polybar
  fzf
  flameshot
)

for app in "${apps[@]}"; do
    echo "Installing $app..."
    sudo apt install -y "$app"
done

snap_apps=(
  --classic go
  spotify
  alacritty
)

for app in "${snap_apps[@]}"; do
    echo "Snap installing $app..."
    sudo snap install "$app"
done

echo "entering a zsh shell for next installs"
zsh

echo "installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git_clones=(
  https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
  https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
  --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
)

# Loop through and install each application
for repo in "${git_clones[@]}"; do
  git clone $repo
done

echo "All installs complete!"
echo "Attempting to configure"

echo "cloning from my github dotfiles (linux) into ~/temp_dotfiles"
git clone https://github.com/justatoaster47/linux_dotfiles.git ~/temp_dotfiles
cp -r ~/temp_dotfiles/* ~/.config/

echo "linking zsh and p10k from config to ~/"
rm ~/.zshrc
rm ~/.p10k.zsh
ln -s ~/.config/zsh/.zshrc ~/.zshrc
ln -s ~/.config/zsh/.p10k.zsh ~/.p10k.zsh
source ~/.zshrc

echo "installing JetBrains Mono Nerd Font"
mkdir -p ~/.local/share/fonts
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip && \
unzip JetBrainsMono.zip -d ~/.local/share/fonts/ && \
rm JetBrainsMono.zip
fc-cache -fv


echo "changing default shell to zsh"
chsh -s $(which zsh)
source ~/.zshrc
