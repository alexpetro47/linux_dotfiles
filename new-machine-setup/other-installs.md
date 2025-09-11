
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
  ripgrep\
  lf\
  btop\
  ranger\
  trash-cli\
  flameshot\
  simplescreenrecorder\
  playerctl\
  vlc\
  cbonsai\
  lldb\
  python3\
  xclip\
  xdotool\
  curl\
  zip\
  unzip\
  wget\
  qjackctl\
  neofetch\
  jq\
  gimp\
  golang\
  zoxide\
  eza\
  texlive-latex-recommended texlive-fonts-recommended\
  texlive-latex-extra texlive-science texlive-pictures\
  texlive-bibtex-extra latexmk texlive-font-utils texlive-plain-generic\
  redis-server\
  ruby-dev\
  pandoc\
  tree\
  openshot-qt\
  rclone\
  keepassxc\
  rename\
  ffmpeg\
  caffeine\
  sqlite-3\
  sqlitebrowser\
  libsqlite3-dev\
  yq\
  bat\
  miller\
  universal-ctags\


## UV (PIP/PIPX ALTERNATIVE)
curl -LsSf https://astral.sh/uv/install.sh | sh

uv tool install jupyterlab
uv tool install ruff
uv tool install pandoc-mermaid-filter
uv tool install pytest

## BUN (NPM/NPX ALTERNATIVE)
curl -fsSL https://bun.sh/install | bash

bun add -g\
  @google/gemini-cli\
  markmap-cli\
  plantuml-cli\
  pm2\
  repomix\
  tsx\
  vercel\
  eslint\
  nodemon\
  serve\
  prettier\
  typescript\
  vscode-langservers-extracted\
  @mermaid-js/mermaid-cli\
  puppeteer\
  @biomejs/biome\
  @ast-grep/cli\

  cc-lsp\

## RUST/CARGO/BINSTALL
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.zshrc
rustup update
cargo install cargo-binstall
rustup component add rust-analyzer rust-src

cargo binstall\
  xh\
  starship\
  ast-grep\
  fd-find\
  sd\
  tree-sitter-cli\

### CLAUDE CODE
curl -fsSL https://claude.ai/install.sh | bash

### **GOOGLE CHROME**
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable

### GIT SETUP
git config --global push.autoSetupRemote true
git config --global init.defaultBranch main

### SPOTIFY
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install spotify-client

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

### NODE/NPM
*(this is a dep for many installs, even if not for personal use)*
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install nodejs

### LUA
curl https://raw.githubusercontent.com/DhavalKapil/luaver/master/install.sh | sh
source ~/.zshrc
luaver install 5.4.7

### LSP SERVERS
go:   `go install golang.org/x/tools/gopls@latest`
lua: via nvim mason
ruby: `gem install --user-install solargraph`

### BLENDER
curl -L https://download.blender.org/release/Blender4.2/blender-4.2.1-linux-x64.tar.xz | tar -xJ -C ~/.local
ln -sf ~/.local/blender-4.2.1-linux-x64/blender ~/.local/bin/blender
which blender

~### DRAW IO~
cd ~/Downloads
wget https://github.com/jgraph/drawio-desktop/releases/download/v28.0.6/drawio-x86_64-28.0.6.AppImage
chmod +x drawio-x86_64-28.0.6.AppImage
mv drawio-x86_64-28.0.6.AppImage ~/.local/bin/drawio

### REAPER
1. download x86_64 version from reaper.fm -> Download
2. extract from tar file...
  * `cd Downloads`
  * `tar -xvf reaper*.xz`
  * cd into extracted folder; same name as above without the .tar.xz
  * `./install-reaper.sh`
  * `ln -s ~/opt/REAPER/reaper ~/.local/bin/reaper`
5. in reaper->settings->audio device
  * auto connect jack to hardware
  * auto connect jack to midi 
  * auto suspend pulseaudio
6. quit reaper
---
1. install jack & dependencies
`sudo apt update && sudo apt install jackd2 qjackctl jack-tools qjackctl`
2. plug in scarlett, check its connected
`aplay -l | grep -i scarlett`
3. configure qjackctl
`qjackctl`
setup -> interface -> find scarlett hw:USB -> save
start
4. open reaper, should be good

### SQLITE VECTOR EXTENSION
`mkdir -p ~/.local/lib && cd ~/.local/lib`
`curl -L https://github.com/asg017/sqlite-vec/releases/download/v0.1.3/sqlite-vec-0.1.3-loadable-linux-x86_64.tar.gz | tar -xz && chmod +x vec0.so`
verify: `sqlite3 :memory: -cmd ".load $HOME/.local/lib/vec0" "SELECT vec_version();"`

### AZURE CLI
`curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash`
`az login`

### D2
curl -fsSL https://d2lang.com/install.sh | sh
which d2

### DBGATE
*download dbgate appimage from https://dbgate.org/download/*
mv ~/Downloads/dbgate-*.AppImage ~/.local/bin/dbgate && chmod +x ~/.local/bin/dbgate
which dbgate && dbgate &

### AST-GREP
(installed via cargo)
ln -s ~/.config/ast-grep/sgconfig.yml ~/.sgconfig.yml

### TREE-SITTER GRAMMARS
`for python`
cd ~/.config/tree-sitter
git clone https://github.com/tree-sitter/tree-sitter-python
cd tree-sitter-python
tree-sitter generate
tree-sitter dump-languages


#### FIREWALL
*for redis local setup, using firewall to block any external access*
*redis config at: `/etc/redis/redis.conf`*
* enable firewall: `sudo ufw enable`
* allow only local access to redis port: `sudo ufw allow from 127.0.0.1 to any port 6379`
* check applied: `sudo ufw status numbered`
---
* Enable auto-start: `sudo systemctl enable redis-server`
* Status: `sudo systemctl status redis-server`
* Test connection: `redis-cli ping` (should return PONG)

#### DISABLE SLEEP/LOCK (PC)
~sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target~



