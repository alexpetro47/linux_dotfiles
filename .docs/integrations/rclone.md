# rclone Integration

Cloud storage sync for backups via Google Drive.

## Installation

Installed via APT in `install-packages.sh`.

## Remote Setup

Create Google Drive remote:

```bash
rclone config
```

1. `n` - New remote
2. Name: `gdrive`
3. Storage type: `Google Drive`
4. Client ID/Secret: Leave blank for rclone's
5. Scope: `drive` (full access)
6. Root folder: Leave blank
7. Service account: No
8. OAuth: Follow browser authentication

## Verify Setup

```bash
rclone listremotes           # Should show gdrive:
rclone lsd gdrive:           # List directories
rclone lsd gdrive:BACKUPS    # Check backup folder
```

## Config Location

`~/.config/rclone/rclone.conf`

Contains encrypted tokens. Back up this file securely.

## Backup Structure

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

## Common Commands

### Sync

```bash
# Sync local to remote (mirror)
rclone sync /local/path gdrive:remote/path

# Copy (don't delete remote)
rclone copy /local/path gdrive:remote/path

# With progress
rclone sync /local/path gdrive:remote/path -P
```

### List

```bash
rclone lsd gdrive:path    # List directories
rclone ls gdrive:path     # List files with sizes
rclone lsl gdrive:path    # List with dates
```

### Download

```bash
rclone copy gdrive:remote/path /local/path
```

### Dry Run

```bash
rclone sync /path gdrive:path --dry-run
```

Shows what would be changed without doing it.

## Backup Scripts

The backup scripts use rclone internally:

- `backup-repos` - Syncs repositories
- `backup-bitwarden` - Syncs vault exports
- `backup-simplenote` - Syncs notes

See [scripts/backup.md](../scripts/backup.md).

## Repo Manifest

`~/.config/rclone/backup-repos.txt`

Format:
```
/path/to/repo:git    # Tracked files only
/path/to/repo:full   # All files
```

## Filters

Exclude patterns in sync:

```bash
rclone sync /path gdrive:path --exclude "node_modules/**" --exclude ".git/**"
```

Or use filter file:

```bash
rclone sync /path gdrive:path --filter-from /path/to/filters.txt
```

## Bandwidth Limiting

```bash
rclone sync /path gdrive:path --bwlimit 1M
```

## Troubleshooting

**Token expired:**
```bash
rclone config reconnect gdrive:
```

**Check connection:**
```bash
rclone about gdrive:
```

**Debug:**
```bash
rclone sync /path gdrive:path -vv
```
