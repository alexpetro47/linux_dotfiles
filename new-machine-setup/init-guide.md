
# INIT GUIDE

sudo apt update + upgrade

## INSTALL CHROME
sudo apt install google-chrome
*log into google account, github*

## GITHUB
*(may need to:) generate net Personal Access Token (classic w. all boxes checked, no expiration) (settings->developer settings-> classic token)* sudo apt install gh 
sudo apt install git
gh auth setup-git
git config --global user.name "Alex Petro"
git config --global user.email "alexmpetro@gmail.com"
git config --list | grep user

## DOTFILES
cd ~ 
git clone https://github.com/justatoaster47/linux_dotfiles
cp -r * linux_dotfiles ./.config

## NVIM
cd ~ 
sudo apt install cmake
git clone --branch stable --depth 1 https://github.com/neovim/neovim.git 
cd neovim 
make CMAKE_BUILD_TYPE=RelWithDebInfo 
sudo make install 
nvim --version && which nvim
use lazy-lock restore if broken packages

## ZSH
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc
rm ~/.p10k.zsh
ln -s ~/.config/zsh/.zshrc ~/.zshrc
ln -s ~/.config/zsh/.p10k.zsh ~/.p10k.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
source ~/.zshrc
chsh -s $(which zsh)

## TMUX/ALACRITTY
sudo apt install tmux alacritty
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/scripts/install_plugins.sh
pkill tmux && rm -rf /tmp/tmux-*

## I3 + Gaps
sudo apt install i3 polybar rofi feh picom
check for syntax: i3 -C -V -c ~/.config/i3/config
sudo apt install meson libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev
libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev
libev-dev libxcb-xrm-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev
libxkbcommon-x11-dev autoconf xutils-dev libtool automake
libxcb-xinerama0-dev libxcb-xrm-dev
cd ~
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
mkdir -p build && cd build
meson ..
ninja
sudo ninja install
pkill -KILL -u $USER

## NERD FONTS + CURSOR THEME
cd ~/Documents
git clone  https://github.com/justatoaster47/os_styling
cd os_styling
mkdir -p /home/alexpetro/.local/share/fonts
cp -r JetBrainsMonoNF/*.ttf /home/alexpetro/.local/share/fonts
mkdir -p /home/alexpetro/.icons
cp -r ComixCursorWhite/ /home/alexpetro/.icons/

other opts listed in the installation.md as well


## SYNC NEW .CONFIG TO GITHUB
cd ~/.config
git init
git checkout -b main
git remote add origin https://github.com/justatoaster47/linux_dotfiles
git branch --set-upstream-to=origin/main
git fetch origin
git rebase
*fix conflicts and push*

## SET UP DOCUMENTS DIR
cd ~/Documents
git clone https://www.github.com/justatoaster47/notes
git clone https://www.github.com/justatoaster47/images
mkdir code
clone any current code projects into Documents/code/
git clone https://www.github.com/justatoaster47/

## OTHER INSTALLS

see [./other-installs.sh]


