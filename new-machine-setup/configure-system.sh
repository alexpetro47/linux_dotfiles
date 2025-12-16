#!/bin/bash
#
# System configuration - git, systemctl, shell, defaults
# Safe to re-run - idempotent operations
#
set -e

log() { echo "[$(date +%H:%M:%S)] $*"; }

# =============================================================================
# GIT GLOBAL CONFIG
# =============================================================================
log "Configuring git..."

git config --global user.name "Alex Petro"
git config --global user.email "alexmpetro@gmail.com"
git config --global push.autoSetupRemote true
git config --global init.defaultBranch main
git config --global credential.helper /usr/bin/git-credential-manager
git config --global credential.credentialStore secretservice

log "Git config set:"
git config --global --list | grep -E "^(user\.|push\.|init\.|credential\.)" | sed 's/^/  /'

# =============================================================================
# DEFAULT SHELL
# =============================================================================
if [ "$SHELL" != "$(which zsh)" ]; then
    log "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
    log "Shell changed - will take effect on next login"
else
    log "Shell already set to zsh"
fi

# =============================================================================
# SYSTEMCTL ENABLES
# =============================================================================
log "Enabling system services..."

sudo systemctl enable greetd 2>/dev/null || log "WARN: greetd enable failed (may not be installed)"
sudo systemctl enable NetworkManager 2>/dev/null || log "WARN: NetworkManager enable failed"
sudo systemctl enable docker 2>/dev/null || log "WARN: docker enable failed"

# =============================================================================
# GREETD CONFIG (tuigreet)
# =============================================================================
GREETD_CONF="/etc/greetd/config.toml"
if [ -f "$GREETD_CONF" ]; then
    log "Configuring greetd..."
    sudo tee "$GREETD_CONF" > /dev/null << 'EOF'
[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd i3 --time --remember --asterisks"
user = "greeter"
EOF
    log "greetd configured for tuigreet + i3"
else
    log "SKIP: greetd config not found (greetd may not be installed)"
fi

# =============================================================================
# DEFAULT APPLICATIONS
# =============================================================================
log "Setting default applications..."

xdg-mime default org.pwmt.zathura.desktop application/pdf 2>/dev/null || true
log "PDF viewer set to zathura"

# =============================================================================
# ENSURE ~/.local/bin IN PATH
# =============================================================================
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    log "NOTE: ~/.local/bin not in PATH - will be added by .zshrc on next shell"
fi

# =============================================================================
# DOCKER GROUP
# =============================================================================
if groups "$USER" | grep -q docker; then
    log "User already in docker group"
else
    log "Adding user to docker group..."
    sudo usermod -aG docker "$USER"
    log "Added to docker group - will take effect on next login"
fi

# =============================================================================
# VERIFICATION
# =============================================================================
log ""
log "Verification:"
log "  OpenGL: $(glxinfo 2>/dev/null | grep 'OpenGL renderer' | cut -d: -f2 | xargs || echo 'N/A')"
log "  Audio:  $(pactl info 2>/dev/null | grep 'Server Name' | cut -d: -f2 | xargs || echo 'N/A')"
log "  Network: $(nmcli device status 2>/dev/null | head -2 | tail -1 || echo 'N/A')"

log ""
log "System configuration complete!"
