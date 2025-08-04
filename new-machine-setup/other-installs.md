
# OTHER INSTALLS


## APT
sudo apt update

sudo apt install\
  git\
  cmake\
  zsh\
  tmux\
  alacritty\
  i3\
  polybar\
  rofi\
  feh\
  picom\
  mintupgrade\
  fzf\
  nemo\
  fd-find\
  ripgrep\
  lf\
  btop\
  ranger\
  trash-cli\
  flameshot\
  simplescreenrecorder\
  playerctl\
  vlc\
  pipes-sh\
  cbonsai\
  lldb\
  clang\
  python3\
  pylint\
  xclip\
  xdotool\
  curl\
  zip\
  wget\
  rclone\
  qjackctl\
  pipx\
  neofetch\
  jq\
  jupyter\
  flatpak\
  gimp\
  golang\
  zoxide\
  eza\


## UV (PIP/PIPX ALTERNATIVE)
curl -LsSf https://astral.sh/uv/install.sh | sh

uv tool install jupyterlab
uv tool install ruff


## BUN (NPM/NPX ALTERNATIVE)
curl -fsSL https://bun.sh/install | bash

bun add -g\
  @anthropic-ai/claude-code\
  @google/gemini-cli\
  markmap-cli\
  plantuml-cli\
  pm2\
  repomix\
  svg-to-excalidraw\
  tsx\
  vercel\
  pyright\
  eslint\
  nodemon\
  serve\
  prettier\
  typescript\

## RUST/CARGO/BINSTALL
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.zshrc
rustup update
cargo install cargo-binstall

cargo binstall\
  xh\
  starship\

### **GOOGLE CHROME**
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable

### SPOTIFY
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install spotify-client

### CURSOR
go to website [https://cursor.com/en/downloads]
cd ~/Downloads
sudo install Cursor-*.AppImage /usr/local/bin/cursor
rm Cursor-*.AppImage






cloudflared
dbeaver
neo4j
need to find latex installs as well
