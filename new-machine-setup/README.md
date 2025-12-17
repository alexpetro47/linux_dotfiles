# New Machine Setup

Automated setup scripts for fresh Ubuntu installs. Idempotent - safe to re-run.

## Quick Start

```bash
# Full auto (i3-gaps, standard packages)
curl -fsSL https://raw.githubusercontent.com/justatoaster47/linux_dotfiles/main/new-machine-setup/bootstrap.sh | bash

# With standard i3 (no gaps)
curl -fsSL ... | INSTALL_I3_GAPS=0 bash

# With optional extras (cloudflared, ngrok, d2, marp, sqlite-vec, blender)
curl -fsSL ... | INSTALL_EXTRAS=1 bash

# Minimal (skip latex, media, browsers)
curl -fsSL ... | SKIP_LATEX=1 SKIP_MEDIA=1 SKIP_BROWSERS=1 bash
```

## Scripts

| Script | Purpose |
|--------|---------|
| `bootstrap.sh` | Entry point - clones repo, orchestrates phases |
| `install-packages.sh` | APT, UV, Rust, Go, Node, browsers, fonts |
| `link-configs.sh` | Symlinks dotfiles to home directory |
| `configure-system.sh` | Git config, systemctl enables, greetd setup |
| `verify.sh` | Post-install verification |

## Phases

1. **Bootstrap** - Clone repo to `~/.config`
2. **Packages** - Install all tooling
3. **Symlinks** - Link configs (`~/.zshrc` → `~/.config/zsh/.zshrc`, etc.)
4. **System config** - Git, systemd, greetd
5. **Verify** - Check installation success

## Options

Set environment variables before running:

```bash
INSTALL_I3_GAPS=1    # Use i3-gaps (default: 1)
INSTALL_EXTRAS=1     # Include optional extras (default: 0)
SKIP_LATEX=1         # Skip texlive (~500MB)
SKIP_MEDIA=1         # Skip vlc, ffmpeg, qjackctl, etc.
SKIP_BROWSERS=1      # Skip chrome, brave, spotify
```

## Adding New Packages

1. **APT package**: Add to `install-packages.sh` APT section
2. **UV tool**: Add `uv tool install <pkg>` line
3. **Cargo tool**: Add to `cargo binstall` line
4. **Go tool**: Add `go install <pkg>@latest` line
5. **Custom install**: Add new section with `if ! installed <cmd>` guard

Always update `../installs.md` to match.

## Post-Install Manual Steps

- Reboot for shell/greetd changes
- `git-credential-manager configure` + authenticate
- `rclone config` for cloud sync
- Import KeePassXC database

## Logs

Bootstrap logs to `~/bootstrap-<timestamp>.log`

## Updating

```bash
cd ~/.config
git pull
./new-machine-setup/install-packages.sh  # re-run any phase
```

## File Locations

| Config | Source | Target |
|--------|--------|--------|
| zsh | `~/.config/zsh/.zshrc` | `~/.zshrc` |
| tmux | `~/.config/tmux/tmux.conf` | `~/.tmux.conf` |
| nvim | `~/.config/nvim/` | (XDG default) |
| i3 | `~/.config/i3/config` | (XDG default) |
| alacritty | `~/.config/alacritty/` | (XDG default) |
