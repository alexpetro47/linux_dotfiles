# New Machine Setup

Automated dotfiles bootstrap for fresh Ubuntu. Idempotent - safe to re-run.

## Quick Start

```bash
# Full install
curl -fsSL https://raw.githubusercontent.com/justatoaster47/linux_dotfiles/main/new-machine-setup/bootstrap.sh | bash
```

### Post-install steps

- `git-credential-manager configure`
- brave: sync account, login to bitwarden browser extension
- spotify login
- `bw login` - authenticate bitwarden CLI (for password backups)

## Re-run Individual Phases

```bash
cd ~/.config/new-machine-setup
./install-packages.sh
./verify.sh
```

Logs: `~/bootstrap-<timestamp>.log`

## Backup

```bash
backup              # interactive menu
backup --all        # bitwarden + repos
backup --repos      # repos only
backup --bitwarden  # passwords only
```

Backups sync to `gdrive:BACKUPS/` via rclone. Requires rclone gdrive remote (see `additional-installs.md`).

