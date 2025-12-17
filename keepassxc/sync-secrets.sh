#!/usr/bin/env bash
# Auto-sync KeePassXC database to Google Drive
# Uses inotifywait to watch for changes, syncs on save

LOCAL_FILE="$HOME/.config/keepassxc/secrets.kdbx"
REMOTE_PATH="google_drive:KEEPASSXC/secrets.kdbx"
SYNC_DELAY=3  # seconds to wait after change before syncing (debounce)

log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

# Ensure local directory exists
mkdir -p "$(dirname "$LOCAL_FILE")"

# Initial sync: pull from remote if newer or local doesn't exist
log "Checking remote for updates..."
if rclone check "$REMOTE_PATH" "$LOCAL_FILE" 2>/dev/null; then
    log "Local file is current"
elif rclone lsf "$REMOTE_PATH" &>/dev/null; then
    log "Pulling latest from Google Drive..."
    rclone copy "$REMOTE_PATH" "$(dirname "$LOCAL_FILE")/" --update
    log "Pull complete"
else
    log "No remote file found, will push on first save"
fi

# Watch for changes and sync
log "Watching $LOCAL_FILE for changes..."
while true; do
    # Wait for file modification (close_write = file saved)
    inotifywait -q -e close_write,moved_to "$(dirname "$LOCAL_FILE")" 2>/dev/null | while read -r dir event file; do
        if [[ "$file" == "$(basename "$LOCAL_FILE")" ]]; then
            log "Change detected, syncing in ${SYNC_DELAY}s..."
            sleep "$SYNC_DELAY"
            rclone copy "$LOCAL_FILE" "$(dirname "$REMOTE_PATH")/"
            log "Synced to Google Drive"
        fi
    done
    # If inotifywait exits (shouldn't happen), restart after delay
    sleep 5
done
