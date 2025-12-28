See `README.md` for setup instructions.

**New files**: When creating new files in this repo, ask user if they want them whitelisted in `.gitignore`.

**Reproducibility**: All changes must be reproducible on a fresh machine. Either:
1. Install script (`install-packages.sh`, `link-configs.sh`, `configure-system.sh`)
2. Passive config (tracked file, symlinked or in XDG path)
3. Documented manual step (`additional-installs.md`)

## Config Changes

| Change | Where |
|--------|-------|
| APT package | `install-packages.sh` → apt block |
| UV/Cargo/Go tool | `install-packages.sh` → respective section |
| Custom binary | `install-packages.sh` → `if ! installed` block |
| New config file | `.gitignore` whitelist + `link-configs.sh` symlink |
| New script | `new-machine-setup/<script>` + `.gitignore` whitelist + `link-configs.sh` symlink to `~/.local/bin/` |
| Tool substitution | install script + `.zshrc` aliases |
| Optional tool | `README.md` → Extras section |

## Idempotency

Scripts are designed for safe re-runs:
- **APT packages**: Always runs `apt install` (apt handles already-installed)
- **Custom binaries**: `if ! installed <cmd>` check before install
- **Symlinks**: Checks if already linked correctly before creating

## Keybindings

| Key | Action |
|-----|--------|
| `Alt+Shift+t` | Toggle theme (dark/light) |
| `Alt+Shift+n` | Toggle focus mode (notifications) |
| `Alt+Shift+b` | Toggle polybar |
| `Alt+Shift+c` | Toggle screen recording (SSR) |

## Theme

- `tinty apply <scheme>` - apply any base16 scheme
- `tinty list | grep <name>` - find schemes
- Config: `~/.config/theme-schemes` (dark/light toggle preferences)

## Backup

```bash
backup              # interactive menu
backup --all        # bitwarden + simplenote + repos
backup --repos      # repos only
backup --bitwarden  # passwords only
backup --simplenote # notes only
backup --dry-run    # preview repo sync
```

- Repos sync to `gdrive:BACKUPS/` via rclone
- Bitwarden: exports to `~/.local/share/bitwarden-backup/`, syncs to `gdrive:BACKUPS/bitwarden/`
- Simplenote: exports to `~/.local/share/simplenote-backup/`, syncs to `gdrive:BACKUPS/SIMPLENOTE/`
- Repos manifest: `rclone/backup-repos.txt` (format: `/path:git` or `/path:full`)
- Setup: `rclone config` → create remote named `gdrive` (see `additional-installs.md`)
- First run: `bw login` for Bitwarden, create `~/.config/simplenote/credentials` (email + password lines)

## Tmux Sessionizer

Source: `~/.config/tmux-sessionizer/tmux-sessionizer` (symlinked to `~/.local/bin/`)

Config: `~/.config/tmux-sessionizer/tmux-sessionizer.conf`
- `TS_EXTRA_SEARCH_PATHS` - directories to search (format: `"path:depth"`)
- `TS_BLACKLIST` - regex patterns to exclude from results




