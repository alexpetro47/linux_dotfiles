#!/bin/bash
#
# Package installation script - idempotent, safe to re-run
# Reference: ../installs.md
#
# Options (set before running or export):
#   INSTALL_I3_GAPS=1    Install i3-gaps instead of standard i3 (default: 1)
#   INSTALL_EXTRAS=0     Install optional extras (cloudflared, ngrok, d2, etc.) (default: 0)
#   SKIP_LATEX=1         Skip texlive packages (~500MB) (default: 0)
#   SKIP_MEDIA=1         Skip media packages (vlc, ffmpeg, qjackctl, etc.) (default: 0)
#   SKIP_BROWSERS=1      Skip browser installs (chrome, brave, spotify) (default: 0)
#
# Example: INSTALL_I3_GAPS=0 ./install-packages.sh       # install regular i3
# Example: INSTALL_EXTRAS=1 ./install-packages.sh        # include optional extras
# Example: SKIP_LATEX=1 SKIP_MEDIA=1 ./install-packages.sh  # minimal install
#
set -e

log() { echo "[$(date +%H:%M:%S)] $*"; }
installed() { command -v "$1" &>/dev/null; }

# =============================================================================
# OPTIONS
# =============================================================================
INSTALL_I3_GAPS="${INSTALL_I3_GAPS:-1}"
INSTALL_EXTRAS="${INSTALL_EXTRAS:-0}"
SKIP_LATEX="${SKIP_LATEX:-0}"
SKIP_MEDIA="${SKIP_MEDIA:-0}"
SKIP_BROWSERS="${SKIP_BROWSERS:-0}"

# =============================================================================
# APT PACKAGES
# =============================================================================
log "Installing APT packages..."
sudo apt update
# Core packages (always installed)
sudo apt install -y \
    git \
    cmake \
    zsh \
    tmux \
    alacritty \
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
    flameshot \
    playerctl \
    cbonsai \
    tty-clock \
    xclip \
    xdotool \
    inotify-tools \
    curl \
    zip \
    unzip \
    wget \
    zoxide \
    eza \
    pandoc \
    rclone \
    keepassxc \
    caffeine \
    sqlite3 \
    libsqlite3-dev \
    greetd \
    pipewire-jack \
    pavucontrol

# Media packages (skip with SKIP_MEDIA=1)
if [ "$SKIP_MEDIA" != "1" ]; then
    log "Installing media packages..."
    sudo apt install -y vlc ffmpeg qjackctl openshot-qt simplescreenrecorder
else
    log "Skipping media packages (SKIP_MEDIA=1)"
fi

# LaTeX packages (skip with SKIP_LATEX=1)
if [ "$SKIP_LATEX" != "1" ]; then
    log "Installing LaTeX packages (~500MB)..."
    sudo apt install -y \
        texlive-latex-recommended texlive-fonts-recommended texlive-xetex \
        texlive-latex-extra texlive-science texlive-pictures \
        texlive-bibtex-extra latexmk texlive-font-utils texlive-plain-generic
else
    log "Skipping LaTeX packages (SKIP_LATEX=1)"
fi

# =============================================================================
# I3 / I3-GAPS
# =============================================================================
if [ "$INSTALL_I3_GAPS" = "1" ]; then
    if ! installed i3 || ! i3 --version 2>/dev/null | grep -q gaps; then
        log "Installing i3-gaps..."
        # Install build dependencies
        sudo apt install -y \
            libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
            libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
            libstartup-notification0-dev libxcb-randr0-dev \
            libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
            libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
            autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev \
            meson ninja-build

        # Clone and build i3-gaps
        I3_GAPS_DIR="/tmp/i3-gaps-build"
        rm -rf "$I3_GAPS_DIR"
        git clone https://github.com/Airblader/i3 "$I3_GAPS_DIR"
        cd "$I3_GAPS_DIR"
        mkdir -p build && cd build
        meson --prefix /usr/local ..
        ninja
        sudo ninja install
        cd ~
        rm -rf "$I3_GAPS_DIR"
        log "i3-gaps installed"
    else
        log "i3-gaps already installed"
    fi
else
    if ! installed i3; then
        log "Installing standard i3..."
        sudo apt install -y i3
    else
        log "i3 already installed"
    fi
fi

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
cargo binstall -y xh starship fd-find tinty tuigreet || true

# Tinty setup (centralized theming)
if installed tinty; then
    log "Setting up tinty..."
    tinty install 2>/dev/null || true
    tinty sync 2>/dev/null || true
    tinty apply base16-gruvbox-dark-medium 2>/dev/null || true
fi

# =============================================================================
# GO
# =============================================================================
if ! installed go; then
    log "Installing Go..."
    GO_VERSION="1.23.4"
    curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
    export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"
else
    log "Go already installed"
fi

log "Installing Go tools..."
go install github.com/jorgerojas26/lazysql@latest || true
go install github.com/xo/usql@latest || true

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
# BROWSERS (skip with SKIP_BROWSERS=1)
# =============================================================================
if [ "$SKIP_BROWSERS" != "1" ]; then
    # GOOGLE CHROME
    if ! installed google-chrome; then
        log "Installing Google Chrome..."
        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg 2>/dev/null || true
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
        sudo apt update
        sudo apt install -y google-chrome-stable
    else
        log "Google Chrome already installed"
    fi

    # BRAVE
    if ! installed brave-browser; then
        log "Installing Brave..."
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        sudo apt update
        sudo apt install -y brave-browser
    else
        log "Brave already installed"
    fi

    # SPOTIFY
    if ! installed spotify; then
        log "Installing Spotify..."
        curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
        echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
        sudo apt update
        sudo apt install -y spotify-client
    else
        log "Spotify already installed"
    fi
else
    log "Skipping browsers (SKIP_BROWSERS=1)"
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

# =============================================================================
# EXTRAS (optional, set INSTALL_EXTRAS=1 to enable)
# =============================================================================
if [ "$INSTALL_EXTRAS" = "1" ]; then
    log "Installing optional extras..."

    # CLOUDFLARED
    if ! installed cloudflared; then
        log "Installing cloudflared..."
        sudo mkdir -p --mode=0755 /usr/share/keyrings
        curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
        echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared jammy main' | sudo tee /etc/apt/sources.list.d/cloudflared.list
        sudo apt update
        sudo apt install -y cloudflared
    else
        log "cloudflared already installed"
    fi

    # D2 (diagram language)
    if ! installed d2; then
        log "Installing d2..."
        curl -fsSL https://d2lang.com/install.sh | sh
    else
        log "d2 already installed"
    fi

    # MARP (markdown presentations)
    if ! installed marp; then
        log "Installing marp..."
        wget -qO- https://github.com/marp-team/marp-cli/releases/latest/download/marp-cli-v4.2.3-linux.tar.gz \
            | sudo tar xz -C /usr/local/bin
    else
        log "marp already installed"
    fi

    # NGROK
    if ! installed ngrok; then
        log "Installing ngrok..."
        curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
            | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
        echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" \
            | sudo tee /etc/apt/sources.list.d/ngrok.list
        sudo apt update
        sudo apt install -y ngrok
        log "NOTE: Run 'ngrok config add-authtoken <token>' after to authenticate"
    else
        log "ngrok already installed"
    fi

    # SQLITE-VEC extension
    if [ ! -f "$HOME/.local/lib/vec0.so" ]; then
        log "Installing sqlite-vec extension..."
        mkdir -p "$HOME/.local/lib"
        curl -L https://github.com/asg017/sqlite-vec/releases/download/v0.1.3/sqlite-vec-0.1.3-loadable-linux-x86_64.tar.gz \
            | tar -xz -C "$HOME/.local/lib"
        chmod +x "$HOME/.local/lib/vec0.so"
    else
        log "sqlite-vec already installed"
    fi

    # BLENDER
    if ! installed blender; then
        log "Installing blender..."
        curl -L https://download.blender.org/release/Blender4.2/blender-4.2.1-linux-x64.tar.xz | tar -xJ -C ~/.local
        ln -sf ~/.local/blender-4.2.1-linux-x64/blender ~/.local/bin/blender
    else
        log "blender already installed"
    fi

    log "Extras installation complete!"
    log "Manual steps remaining:"
    log "  - ngrok: run 'ngrok config add-authtoken <token>'"
    log "  - See installs.md EXTRAS section for: REAPER, DBGATE, NEO4J, AZURE CLI, LUA, nerd-dictation"
else
    log "Skipping extras (set INSTALL_EXTRAS=1 to include)"
fi

log "Package installation complete!"
