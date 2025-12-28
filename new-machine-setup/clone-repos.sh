#!/bin/bash
#
# Clone git repos from clone-repos.txt
# Safe to re-run - skips existing repos
#
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPOS_FILE="$SCRIPT_DIR/clone-repos.txt"

log() { echo "[$(date +%H:%M:%S)] $*"; }

if [ ! -f "$REPOS_FILE" ]; then
    log "No clone-repos.txt found, skipping"
    exit 0
fi

log "Cloning repos from $REPOS_FILE..."

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    # Parse repo URL and destination
    read -r repo_url dest <<< "$line"

    # Expand ~ to $HOME
    dest="${dest/#\~/$HOME}"

    if [ -z "$repo_url" ] || [ -z "$dest" ]; then
        log "WARN: Invalid line: $line"
        continue
    fi

    if [ -d "$dest/.git" ]; then
        log "Already cloned: $dest"
    elif [ -d "$dest" ]; then
        # Directory exists but not a git repo - back it up
        backup="${dest}.bak-$(date +%Y%m%d-%H%M%S)"
        log "Backing up existing $dest -> $backup"
        mv "$dest" "$backup"
        log "Cloning $repo_url -> $dest"
        git clone "$repo_url" "$dest"
    else
        log "Cloning $repo_url -> $dest"
        mkdir -p "$(dirname "$dest")"
        git clone "$repo_url" "$dest"
    fi
done < "$REPOS_FILE"

log "Repo cloning complete!"
