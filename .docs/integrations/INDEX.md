# Integrations Documentation

External service connections and credentials management.

## Contents

| File | Description |
|------|-------------|
| [bitwarden.md](bitwarden.md) | Bitwarden CLI and Secrets Manager (bws) for password and API key management. |
| [rclone.md](rclone.md) | rclone configuration for Google Drive backup sync. |
| [remote-access.md](remote-access.md) | SSH access to mini PC (UM890PRO) for ralph daemon and training. |
| [secrets.md](secrets.md) | Secrets management patterns: env files, keyring, and bws integration. |

## Integration Summary

| Service | Purpose | Auth Method |
|---------|---------|-------------|
| Bitwarden | Password management | Master password + session |
| Bitwarden Secrets | API keys | Access token in keyring |
| Google Drive | Cloud backup | OAuth via rclone |
| Mini PC | Remote compute | SSH keys |
| GitHub | Code hosting | Git Credential Manager |

## Credential Storage

| Type | Storage Location |
|------|------------------|
| API keys | `~/.claude/.env` |
| BWS access token | GNOME keyring |
| Bitwarden session | bw CLI manages |
| SSH keys | `~/.ssh/` |
| rclone tokens | `~/.config/rclone/rclone.conf` |

## Quick Commands

### Bitwarden

```bash
bw login              # Authenticate
bw unlock             # Start session
bw sync               # Sync vault
bws-get <secret-id>   # Get secret via bws
bws-list              # List secrets
```

### Backup

```bash
backup --all          # Full backup
rclone lsd gdrive:    # List remote dirs
```

### Remote Access

```bash
pc                    # SSH to mini PC
pcsync                # Sync files to mini PC
```

## Setup Order

1. **Git Credential Manager** - First git push authenticates
2. **Bitwarden CLI** - `bw login`
3. **rclone** - `rclone config` for gdrive
4. **BWS** - Store access token in keyring
5. **SSH** - Copy keys or generate new
