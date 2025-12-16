#!/bin/bash
#
# Bootstrap script for new machine setup
# Usage: curl -fsSL https://raw.githubusercontent.com/justatoaster47/linux_dotfiles/main/new-machine-setup/bootstrap.sh | bash
#
set -e

REPO_URL="https://github.com/justatoaster47/linux_dotfiles.git"
CONFIG_DIR="$HOME/.config"
SETUP_DIR="$CONFIG_DIR/new-machine-setup"
LOG_FILE="$HOME/bootstrap-$(date +%Y%m%d-%H%M%S).log"

log() { echo "[$(date +%H:%M:%S)] $*" | tee -a "$LOG_FILE"; }
err() { log "ERROR: $*"; exit 1; }

log "Starting bootstrap - logging to $LOG_FILE"

# Phase 0: Minimal dependencies
log "Installing minimal dependencies..."
sudo apt update
sudo apt install -y git curl wget unzip

# Phase 1: Clone or update repo
if [ -d "$CONFIG_DIR/.git" ]; then
    log "Config repo exists, pulling latest..."
    git -C "$CONFIG_DIR" pull --ff-only || log "WARN: Pull failed, continuing with existing state"
else
    log "Cloning dotfiles repo..."
    # Backup existing .config if it exists and isn't empty
    if [ -d "$CONFIG_DIR" ] && [ "$(ls -A $CONFIG_DIR)" ]; then
        BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
        log "Backing up existing .config to $BACKUP"
        mv "$CONFIG_DIR" "$BACKUP"
    fi
    git clone "$REPO_URL" "$CONFIG_DIR"
fi

# Phase 2: Run setup scripts
cd "$SETUP_DIR"

log "Phase 2: Installing packages..."
bash install-packages.sh 2>&1 | tee -a "$LOG_FILE"

log "Phase 3: Creating symlinks..."
bash link-configs.sh 2>&1 | tee -a "$LOG_FILE"

log "Phase 4: System configuration..."
bash configure-system.sh 2>&1 | tee -a "$LOG_FILE"

log "Bootstrap complete! Log saved to $LOG_FILE"
log ""
log "Manual steps remaining:"
log "  1. Reboot or logout/login for shell changes"
log "  2. Run 'git-credential-manager configure' and authenticate"
log "  3. Configure rclone: 'rclone config'"
log "  4. Import KeePassXC database"
log ""
