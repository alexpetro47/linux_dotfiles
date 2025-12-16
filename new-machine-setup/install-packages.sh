#!/bin/bash
#
# Package installation script - idempotent, safe to re-run
# Reference: ../installs.md
#
set -e

log() { echo "[$(date +%H:%M:%S)] $*"; }
installed() { command -v "$1" &>/dev/null; }

# =============================================================================
# APT PACKAGES
# =============================================================================
log "Installing APT packages..."
sudo apt update
sudo apt install -y \
    git \
    cmake \
    zsh \
    tmux \
    alacritty \
    i3 \
    polybar \
    rofi \
    feh \
    picom \
    fzf \
    nemo \
    ripgrep \
    btop \
    trash-cli \
    zathura zathura-pdf-poppler \
    vlc \
    flameshot \
    simplescreenrecorder \
    playerctl \
    cbonsai \
    xclip \
    xdotool \
    curl \
    zip \
    unzip \
    wget \
    qjackctl \
    zoxide \
    eza \
    pandoc \
    openshot-qt \
    rclone \
    keepassxc \
    ffmpeg \
    caffeine \
    texlive-latex-recommended texlive-fonts-recommended texlive-xetex \
    texlive-latex-extra texlive-science texlive-pictures \
    texlive-bibtex-extra latexmk texlive-font-utils texlive-plain-generic \
    sqlite3 \
    libsqlite3-dev \
    greetd \
    pipewire-jack \
    pavucontrol

# =============================================================================
# UV (Python package manager)
# =============================================================================
if ! installed uv; then
    log "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
else
    log "uv already installed"
fi

log "Installing uv tools..."
uv tool install jupyterlab || true
uv tool install ruff || true
uv tool install pytest || true
uv tool install pyright || true
uv tool install pre-commit || true

# =============================================================================
# RUST/CARGO
# =============================================================================
if ! installed rustup; then
    log "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    log "Rust already installed, updating..."
    rustup update
fi

rustup component add rust-analyzer rust-src || true

if ! installed cargo-binstall; then
    log "Installing cargo-binstall..."
    cargo install cargo-binstall
fi

log "Installing cargo packages..."
cargo binstall -y xh starship fd-find tuigreet || true

# =============================================================================
# NODE/NPM
# =============================================================================
if ! installed node; then
    log "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    log "Node.js already installed"
fi

# =============================================================================
# GOOGLE CHROME
# =============================================================================
if ! installed google-chrome; then
    log "Installing Google Chrome..."
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg 2>/dev/null || true
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update
    sudo apt install -y google-chrome-stable
else
    log "Google Chrome already installed"
fi

# =============================================================================
# BRAVE
# =============================================================================
if ! installed brave-browser; then
    log "Installing Brave..."
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
else
    log "Brave already installed"
fi

# =============================================================================
# SPOTIFY
# =============================================================================
if ! installed spotify; then
    log "Installing Spotify..."
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update
    sudo apt install -y spotify-client
else
    log "Spotify already installed"
fi

# =============================================================================
# LAZYGIT
# =============================================================================
if ! installed lazygit; then
    log "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo install /tmp/lazygit -D -t /usr/local/bin/
    rm /tmp/lazygit.tar.gz /tmp/lazygit
else
    log "lazygit already installed"
fi

# =============================================================================
# GIT CREDENTIAL MANAGER
# =============================================================================
if ! installed git-credential-manager; then
    log "Installing Git Credential Manager..."
    curl -L https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.0/gcm-linux_amd64.2.6.0.deb -o /tmp/gcm.deb
    sudo dpkg -i /tmp/gcm.deb
    rm /tmp/gcm.deb
else
    log "Git Credential Manager already installed"
fi

# =============================================================================
# CLAUDE CODE
# =============================================================================
if ! installed claude; then
    log "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    log "Claude Code already installed"
fi

log "Configuring Claude Code MCP servers..."
claude mcp add context7 -s user -- npx -y @upstash/context7-mcp@latest 2>/dev/null || true
claude mcp add sequential-thinking -s user -- npx -y @modelcontextprotocol/server-sequential-thinking 2>/dev/null || true
claude mcp add playwright -s user -- npx '@playwright/mcp@latest' 2>/dev/null || true

# =============================================================================
# FONTS (FiraCode Nerd Font)
# =============================================================================
if [ ! -d "$HOME/.local/share/fonts/FiraCode" ]; then
    log "Installing FiraCode Nerd Font..."
    mkdir -p "$HOME/.local/share/fonts"
    curl -fLo /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
    unzip -o /tmp/FiraCode.zip -d "$HOME/.local/share/fonts/FiraCode"
    fc-cache -fv
    rm /tmp/FiraCode.zip
else
    log "FiraCode Nerd Font already installed"
fi

# =============================================================================
# DOCKER
# =============================================================================
if ! installed docker; then
    log "Installing Docker..."
    sudo apt install -y docker.io docker-compose
    sudo usermod -aG docker "$USER"
else
    log "Docker already installed"
fi

log "Package installation complete!"
