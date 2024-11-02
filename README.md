# Installs (macOS)

### Quick neovim setup:
```
curl -o ~/.config/init.lua https://raw.githubusercontent.com/justatoaster47/dotfiles/main/nvim/init.lua
```
## homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
## alacritty
```
brew tap homebrew/cask
brew install --cask alacritty
```
## main installs (homebrew / apt (sudo, update and upgrade first))
```
zsh tmux fzf ripgrep neovim git openssh
(or openssh-server)
```
## nice to have (brew installs) (MacTeX is large)
```
lldb pandoc MacTex bfg
(mac only) amethyst, stats, displaperture, raycast
basictex as a smaller alternative to MacTex
```
## oh-my-zsh, zsh plugins, powerlevel10k
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```
## tmux plugin manager
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

# Other
## change .zshrc 'export ZSH' path depending on username and if linux/mac
## source tmux.conf, download tmux plugins(in tmux: prefix + capital I)
```
source ~/.config/tmux/tmux.conf
```
## change shell to zsh 
```
chsh -s $(which zsh)
source ~/.zshrc
```
## place dotfiles contents in ~/.config. predelete duplicates as needed.
```
git clone https://github.com/justatoaster47/dotfiles.git ~/myCONFIG
cp -r ~/myCONFIG/* ~/.config/
```
## symlink .zshrc and .p10k.zsh to home dir from config
```
rm ~/.zshrc
rm ~/.p10k.zsh
ln -s ~/.config/zsh/.zshrc ~/.zshrc
ln -s ~/.config/zsh/.p10k.zsh ~/.p10k.zsh
source ~/.zshrc
```

# Misc
### nerd fonts for alacritty config, works with powerlevel10k
```
brew install homebrew/cask-fonts/font-jetbrains-mono-nerd-font
```
### Neovim doesn't comply sometimes, will only update to 0.7.2, so use this to replace with appimage
```
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
sudo apt remove neovim
```
### shits and gigggles (homebrew)
```
macchina cmatrix cbonsai
```
### workflow
ctrl-j for terminal (alacritty, using raycast) (toggle open+show/hide)
ctrl-k for browser (firefox, using raycast) (toggle open+show/hide)
ctrl-l for cycle tiling layout (amethyst, only options are fullscreen or split)
ctrl-' to reboot (amethyst)
ctrl-; to move focus clockwise (amethyst)
c-w jkl for (tmux) 123 windows
JKL for (harpoon) 123 files
cmd-ctrl jkl; desktop switching (mac)
