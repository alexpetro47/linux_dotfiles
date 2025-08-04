
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
  texlive-latex-recommended texlive-fonts-recommended\
  texlive-latex-extra texlive-science texlive-pictures\
  texlive-bibtex-extra latexmk texlive-font-utils texlive-plain-generic\


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
***go to website [https://cursor.com/en/downloads] & download in browser***
cd ~/Downloads
sudo install Cursor-*.AppImage /usr/local/bin/cursor
rm Cursor-*.AppImage

### CLOUDFLARED
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared jammy main' | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt update
sudo apt install cloudflared

### NEO4J
curl -fsSL https://debian.neo4j.com/neotechnology.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/neotechnology.gpg
echo "deb [signed-by=/usr/share/keyrings/neotechnology.gpg] https://debian.neo4j.com stable latest" | sudo tee /etc/apt/sources.list.d/neo4j.list
sudo apt update && sudo apt install neo4j

