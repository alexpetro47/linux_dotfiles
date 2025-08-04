
# OTHER INSTALLS


## APT
sudo apt update &&\
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
  cargo\
  rustc\

## UV (PIP/PIPX ALTERNATIVE)
curl -LsSf https://astral.sh/uv/install.sh | sh

uv tool install jupyterlab
uv tool install ruff
uv tool install httpie


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


## CARGO 
cargo-tauri

## APP IMAGES
cursor
neo4j

need to find latex installs as well


## VIA GPG KEY

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

cloudflared
dbeaver
