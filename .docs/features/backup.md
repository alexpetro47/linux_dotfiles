# Backup System

Versioned backup system for repositories, Bitwarden vault, and Simplenote notes. Uses rclone for Google Drive synchronization.

## Quick Usage

```bash
backup              # Interactive menu
backup --all        # Everything
backup --repos      # Repositories only
backup --bitwarden  # Vault only
backup --simplenote # Notes only
backup --dry-run    # Preview without changes
```

## Components

### Interactive Menu (`backup`)

Main entry point. Presents menu:
```
1. All (Bitwarden + Simplenote + Repos)
2. Repos only
3. Simplenote only
```

Location: `new-machine-setup/scripts/backup`

### Repository Backup (`backup-repos`)

Git-aware repository sync to cloud.

**Manifest file:** `rclone/backup-repos.txt`

Format:
```
/path/to/repo:git    # Only tracked files
/path/to/repo:full   # All files
```

Default repos:
- `~/.claude` (git mode)
- `~/.config` (git mode)

**Versioning:**
- Creates timestamped directory: `<name>.YYYY-MM-DD_HH-MM/`
- Keeps 3 most recent versions
- Changed/deleted files moved to version directory

**Commands:**
```bash
backup-repos                    # Sync all repos in manifest
backup-repos --dry-run          # Preview sync
```

Location: `new-machine-setup/scripts/backup-repos`

### Bitwarden Backup (`backup-bitwarden`)

Encrypted vault export and sync.

**Process:**
1. Prompts for master password (if vault locked)
2. Prompts for backup encryption PIN
3. Exports vault as encrypted JSON
4. Stores locally: `~/.local/share/bitwarden-backup/`
5. Syncs to: `gdrive:BACKUPS/bitwarden/`

**Local retention:** 7 exports

**Commands:**
```bash
backup-bitwarden
```

Location: `new-machine-setup/scripts/backup-bitwarden`

### Simplenote Backup (`backup-simplenote`)

Notes sync via simplenote-backup tool.

**Credentials:** `~/.config/simplenote/credentials`
```
email@example.com
password
```

**Local storage:** `~/.local/share/simplenote-backup/`

**Remote:** `gdrive:BACKUPS/SIMPLENOTE/`

**Versioning:** Same pattern as repos (timestamped, 3 retained)

## rclone Remote Setup

1. Run configuration:
   ```bash
   rclone config
   ```

2. Create new remote:
   - Name: `gdrive`
   - Type: `Google Drive`
   - Follow OAuth prompts

3. Verify:
   ```bash
   rclone listremotes | grep gdrive
   rclone lsd gdrive:BACKUPS
   ```

## Cloud Structure

```
gdrive:BACKUPS/
├── .claude/                    # Latest
├── .claude.2025-01-15_14-30/   # Version 1
├── .claude.2025-01-14_10-00/   # Version 2
├── .config/
├── .config.2025-01-15_14-30/
├── bitwarden/
│   └── vault_YYYY-MM-DD.json
└── SIMPLENOTE/
    └── SIMPLENOTE.2025-01-15/
```

## Adding Repos to Backup

Edit `~/.config/rclone/backup-repos.txt`:

```bash
echo "/home/user/projects/myrepo:git" >> ~/.config/rclone/backup-repos.txt
```

## Dry Run

Preview what would be synced:

```bash
backup --dry-run
backup-repos --dry-run
```

Shows:
- Files to upload
- Files to delete remotely
- Size changes

## Restore

Restore from cloud:

```bash
# List available versions
rclone lsd gdrive:BACKUPS/ | grep .config

# Restore specific version
rclone copy gdrive:BACKUPS/.config.2025-01-15_14-30/ ~/.config/

# Restore latest
rclone copy gdrive:BACKUPS/.config/ ~/.config/
```

## Automation

Not currently automated. Run manually or add to cron:

```bash
# Weekly full backup (add to crontab)
0 2 * * 0 /home/user/.local/bin/backup --all
```
