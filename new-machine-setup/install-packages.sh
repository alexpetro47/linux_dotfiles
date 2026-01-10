#!/bin/bash
#
# Package installation script - idempotent, safe to re-run
# Optional/extras: see installs.md for manual install commands
#
# Options (set before running or export):
#   SKIP_LATEX=1         Skip texlive packages (~500MB) (default: 0)
#
# Example: SKIP_LATEX=1 ./install-packages.sh  # skip large LaTeX packages
#
set -e

log() { echo "[$(date +%H:%M:%S)] $*"; }
installed() { command -v "$1" &>/dev/null; }

# =============================================================================
# OPTIONS
# =============================================================================
SKIP_LATEX="${SKIP_LATEX:-0}"

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
    nsxiv \
    picom \
    fzf \
    ripgrep \
    btop \
    trash-cli \
    zathura zathura-pdf-poppler \
    flameshot \
    playerctl \
    brightnessctl \
    cbonsai \
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
    caffeine \
    sqlite3 \
    libsqlite3-dev \
    pipewire-jack \
    pavucontrol \
    thunar \
    sox \
    libsox-fmt-all \
    # TLP power management for battery optimization
    tlp \
    tlp-rdw \

# =============================================================================
# BROWSERS
# =============================================================================
# GOOGLE CHROME
if ! installed google-chrome; then
    log "Installing Google Chrome..."
    curl -fsSLo /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i /tmp/google-chrome.deb
    sudo apt-get install -f -y
    rm /tmp/google-chrome.deb
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
# I3
# =============================================================================
if ! installed i3; then
    log "Installing i3..."
    sudo apt install -y i3
else
    log "i3 already installed"
fi

# Backlight permissions (for brightness keys without root)
if [ ! -f /etc/udev/rules.d/90-backlight.rules ]; then
    log "Setting up backlight permissions..."
    echo 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"' | sudo tee /etc/udev/rules.d/90-backlight.rules
    sudo usermod -aG video "$USER"
    sudo udevadm control --reload-rules && sudo udevadm trigger
else
    log "Backlight udev rule already exists"
fi

# Ensure i3 session file exists for login screen
if [ ! -f /usr/share/xsessions/i3.desktop ]; then
    log "Creating i3 session file..."
    sudo tee /usr/share/xsessions/i3.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=i3
Comment=improved dynamic tiling window manager
Exec=i3
TryExec=i3
Type=Application
X-LightDM-DesktopName=i3
DesktopNames=i3
Keywords=tiling;wm;windowmanager;window;manager;
EOF
else
    log "i3 session file already exists"
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
uv tool install whisper-ctranslate2 || true

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
cargo binstall -y xh fd-find tinty || true

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

# Configure npm to use user directory (avoids sudo for global installs)
npm config set prefix ~/.local

log "Installing npm global packages..."
npm install -g markserv

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
# TMUX SESSIONIZER
# =============================================================================
if [ ! -f "$HOME/.local/bin/tmux-sessionizer" ]; then
    log "Installing tmux-sessionizer..."
    mkdir -p "$HOME/.local/bin"
    curl -o "$HOME/.local/bin/tmux-sessionizer" https://raw.githubusercontent.com/ThePrimeagen/tmux-sessionizer/master/tmux-sessionizer
    chmod +x "$HOME/.local/bin/tmux-sessionizer"
else
    log "tmux-sessionizer already installed"
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

# log "Configuring Claude Code MCP servers..."
# claude mcp add context7 -- npx -y @upstash/context7-mcp@latest 2>/dev/null || true
# claude mcp add sequential-thinking -s user -- npx -y @modelcontextprotocol/server-sequential-thinking 2>/dev/null || true
# claude mcp add playwright -- npx '@playwright/mcp@latest' 2>/dev/null || true

# log "Installing Claude Code plugins..."
# npx claude-plugins skills install @anthropics/claude-code/frontend-design 2>/dev/null || true

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
# CURSOR THEME (ComixCursors-White)
# =============================================================================
if [ ! -d /usr/share/icons/ComixCursors-White ]; then
    log "Installing ComixCursors theme..."
    sudo apt install -y comixcursors-righthanded
else
    log "ComixCursors theme already installed"
fi

# =============================================================================
# NEOVIM (from source)
# =============================================================================
if ! installed nvim; then
    log "Installing Neovim from source..."
    sudo apt install -y ninja-build gettext cmake unzip curl build-essential
    git clone --branch stable --depth 1 https://github.com/neovim/neovim.git /tmp/neovim-build
    cd /tmp/neovim-build
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd ~
    rm -rf /tmp/neovim-build
else
    log "Neovim already installed"
fi

# =============================================================================
# TPM (tmux plugin manager)
# =============================================================================
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    log "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    log "TPM already installed"
fi

# Install tmux plugins non-interactively (requires tmux.conf to be linked)
if [ -f "$HOME/.tmux.conf" ] && [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
    log "Installing tmux plugins..."
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" || log "WARN: tmux plugin install failed (may need tmux running)"
fi

# =============================================================================
# ASCIIQUARIUM (terminal aquarium for zen-mode)
# =============================================================================
if ! installed asciiquarium; then
    log "Installing asciiquarium..."
    sudo apt install -y libcurses-perl
    # Install Term::Animation from CPAN (required dependency)
    sudo cpan -T Term::Animation 2>/dev/null || log "WARN: Term::Animation install may need manual CPAN config"
    # Download and install asciiquarium
    curl -fLo /tmp/asciiquarium.tar.gz https://robobunny.com/projects/asciiquarium/asciiquarium.tar.gz
    tar -xzf /tmp/asciiquarium.tar.gz -C /tmp
    sudo install /tmp/asciiquarium_1.1/asciiquarium /usr/local/bin/
    rm -rf /tmp/asciiquarium.tar.gz /tmp/asciiquarium_1.1
else
    log "asciiquarium already installed"
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
# BITWARDEN CLI (native binary)
# =============================================================================
if ! installed bw; then
    log "Installing Bitwarden CLI..."
    BW_VERSION=$(curl -s "https://api.github.com/repos/bitwarden/clients/releases?per_page=50" | grep -Po '"tag_name": *"cli-v\K[^"]*' | head -1)
    curl -fLo /tmp/bw.zip "https://github.com/bitwarden/clients/releases/download/cli-v${BW_VERSION}/bw-linux-${BW_VERSION}.zip"
    unzip -o /tmp/bw.zip -d /tmp
    sudo install /tmp/bw /usr/local/bin/
    rm /tmp/bw.zip /tmp/bw
else
    log "Bitwarden CLI already installed"
fi

# =============================================================================
# REAPER DAW (manual download required)
# =============================================================================
if [ ! -f "$HOME/.local/opt/reaper/reaper" ]; then
    log "Reaper not found. Download from https://www.reaper.fm/download.php"
    log "Then extract to ~/.local/opt/reaper/"
else
    log "Reaper already installed"
fi

# Create reaper wrapper with PipeWire low-latency settings
if [ ! -f "$HOME/.local/bin/reaper" ]; then
    log "Creating Reaper launcher wrapper..."
    mkdir -p "$HOME/.local/bin"
    cat > "$HOME/.local/bin/reaper" << 'EOF'
#!/bin/bash
# Launch Reaper with PipeWire low-latency settings
# 256 samples at 48kHz = ~5.3ms latency
# Audio setup: Preferences → Audio → Device → ALSA, pick hw:Stomp from dropdown
export PIPEWIRE_LATENCY="256/48000"
exec ~/.local/opt/reaper/reaper "$@"
EOF
    chmod +x "$HOME/.local/bin/reaper"
else
    log "Reaper wrapper already exists"
fi

# =============================================================================
# CLEANUP
# =============================================================================
log "Cleaning up orphaned packages..."
sudo apt autoremove -y

log "Package installation complete!"

# =============================================================================
# AUTO-LOGOUT (to select i3 at login)
# =============================================================================
if [ -f /usr/share/xsessions/i3.desktop ] && [ -n "$DISPLAY" ]; then
    log "i3 session available. Logging out in 5 seconds to switch session..."
    log "Press Ctrl+C to cancel"
    sleep 5
    # Try various logout methods
    if installed gnome-session-quit; then
        gnome-session-quit --no-prompt --logout
    elif installed loginctl; then
        loginctl terminate-user "$USER"
    else
        pkill -KILL -u "$USER"
    fi
fi
