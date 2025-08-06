
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
  cbonsai\
  lldb\
  clangd\
  python3\
  xclip\
  xdotool\
  curl\
  zip\
  unzip\
  wget\
  rclone\
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


## UV (PIP/PIPX ALTERNATIVE)
curl -LsSf https://astral.sh/uv/install.sh | sh

uv tool install jupyterlab
uv tool install ruff
uv tool install python-lsp-server

## BUN (NPM/NPX ALTERNATIVE)
curl -fsSL https://bun.sh/install | bash

bun add -g\
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
  cc-lsp\
  typescript-language-server\
  typescript\
  vscode-langservers-extracted\


## RUST/CARGO/BINSTALL
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.zshrc
rustup update
cargo install cargo-binstall
rustup component add rust-analyzer rust-src

cargo binstall\
  xh\
  starship\

### CLAUDE CODE
curl -fsSL https://claude.ai/install.sh | bash

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





##### COMPLETE CHECKS
```

echo "=== SYSTEM TOOLS (APT) ==="
for tool in git cmake zsh tmux alacritty i3 polybar rofi feh picom fzf nemo fdfind rg lf btop ranger trash flameshot simplescreenrecorder playerctl vlc cbonsai lldb clangd python3 xclip xdotool curl zip unzip wget rclone qjackctl neofetch jq gimp go zoxide eza pdflatex latexmk redis-server lua-language-server; do
  which $tool >/dev/null && echo "✅ $tool" || echo "❌ $tool"
done

echo ""
echo "=== UV TOOLS ==="
for tool in uv; do
  which $tool >/dev/null && echo "✅ $tool" || echo "❌ $tool"
done
uv tool list 2>/dev/null && echo "✅ UV tools installed" || echo "❌ UV tools missing"

echo ""
echo "=== BUN TOOLS ==="
for tool in bun node npm gemini markmap plantuml-cli pm2 repomix tsx vercel pyright eslint nodemon serve prettier tsc typescript-language-server ; do
  which $tool >/dev/null && echo "✅ $tool" || echo "❌ $tool"
done

echo ""
echo "=== RUST/CARGO TOOLS ==="
for tool in rustc cargo rustup xh starship; do
  which $tool >/dev/null && echo "✅ $tool" || echo "❌ $tool"
done

echo ""
echo "=== LANGUAGE SERVERS (MINIMAL) ==="
for server in typescript-language-server clangd gopls rust-analyzer lua-language-server; do
  which $server >/dev/null && echo "✅ $server" || echo "❌ $server"
done
uvx --from python-lsp-server pylsp --version >/dev/null 2>&1 && echo "✅ python-lsp-server" || echo "❌ python-lsp-server"


echo ""
echo "=== OTHER APPLICATIONS ==="
for app in claude google-chrome spotify cloudflared neo4j; do
  which $app >/dev/null && echo "✅ $app" || echo "❌ $app"
done

echo ""
echo "=== RUNTIME VERSIONS ==="
python3 --version 2>/dev/null && echo "✅ Python" || echo "❌ Python"
go version 2>/dev/null && echo "✅ Go" || echo "❌ Go" 
rustc --version 2>/dev/null && echo "✅ Rust" || echo "❌ Rust"
ruby --version 2>/dev/null && echo "✅ Ruby" || echo "❌ Ruby"
node --version 2>/dev/null && echo "✅ Node" || echo "❌ Node"
bun --version 2>/dev/null && echo "✅ Bun" || echo "❌ Bun"
```


