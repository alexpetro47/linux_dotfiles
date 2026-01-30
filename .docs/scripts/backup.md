# Backup Scripts

Scripts for backing up repositories, Bitwarden vault, and Simplenote to Google Drive via rclone.

## backup

Interactive backup menu.

**Location:** `new-machine-setup/scripts/backup`

**Usage:**
```bash
backup              # Interactive menu
backup --all        # Everything
backup --repos      # Repositories only
backup --bitwarden  # Vault only
backup --simplenote # Notes only
backup --dry-run    # Preview without changes
```

**Menu options:**
```
1. All (Bitwarden + Simplenote + Repos)
2. Repos only
3. Simplenote only
```

## backup-repos

Git-aware repository sync to cloud.

**Location:** `new-machine-setup/scripts/backup-repos`

**Usage:**
```bash
backup-repos            # Sync all repos in manifest
backup-repos --dry-run  # Preview sync
```

**Manifest:** `~/.config/rclone/backup-repos.txt`

**Format:**
```
/path/to/repo:git    # Only tracked files (respects .gitignore)
/path/to/repo:full   # All files
```

**Default repos:**
```
/home/alexpetro/.claude:git
/home/alexpetro/.config:git
```

**Versioning:**
- Creates `<name>.YYYY-MM-DD_HH-MM/` directory
- Keeps 3 most recent versions
- Changed/deleted files moved to version directory

**Remote:** `gdrive:BACKUPS/`

## backup-bitwarden

Encrypted vault export and sync.

**Location:** `new-machine-setup/scripts/backup-bitwarden`

**Usage:**
```bash
backup-bitwarden
```

**Process:**
1. Check if vault locked → prompt for master password
2. Prompt for backup encryption PIN
3. Export vault as encrypted JSON
4. Save to local directory
5. Sync to Google Drive

**Local storage:** `~/.local/share/bitwarden-backup/`
**Remote:** `gdrive:BACKUPS/bitwarden/`
**Local retention:** 7 exports

## backup-simplenote

Notes backup via simplenote-backup tool.

**Location:** `new-machine-setup/scripts/backup-simplenote`

**Usage:**
```bash
backup-simplenote
```

**Credentials required:** `~/.config/simplenote/credentials`
```
email@example.com
password
```

**Local storage:** `~/.local/share/simplenote-backup/`
**Remote:** `gdrive:BACKUPS/SIMPLENOTE/`
**Versioning:** Same as repos (timestamped, 3 retained)

## Prerequisites

### rclone Remote

Must have `gdrive` remote configured:

```bash
rclone config
# Name: gdrive
# Type: Google Drive
# Follow OAuth flow
```

Verify:
```bash
rclone listremotes | grep gdrive
```

### Bitwarden CLI

For vault backup:

```bash
bw login
```

### Simplenote Credentials

Create file:
```bash
mkdir -p ~/.config/simplenote
cat > ~/.config/simplenote/credentials << 'EOF'
your-email@example.com
your-password
EOF
chmod 600 ~/.config/simplenote/credentials
```

## Adding Repos to Backup

Edit manifest:

```bash
echo "/path/to/new/repo:git" >> ~/.config/rclone/backup-repos.txt
```

Then run:
```bash
backup-repos
```

## Restore

See [features/backup.md](../features/backup.md) for restore instructions.
