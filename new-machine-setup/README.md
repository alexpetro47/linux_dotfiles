# New Machine Setup

Automated dotfiles bootstrap for fresh Ubuntu. Idempotent - safe to re-run.

## Quick Start

```bash
# Full install (i3-gaps, all standard packages)
curl -fsSL https://raw.githubusercontent.com/justatoaster47/linux_dotfiles/main/new-machine-setup/bootstrap.sh | bash

# Minimal install
curl -fsSL ... | SKIP_LATEX=1 SKIP_MEDIA=1 SKIP_BROWSERS=1 bash

# With extras (cloudflared, ngrok, d2, blender, etc.)
curl -fsSL ... | INSTALL_EXTRAS=1 bash
```

## Flags

| Flag | Effect |
|------|--------|
| `INSTALL_I3_GAPS=0` | Standard i3 instead of i3-gaps |
| `INSTALL_EXTRAS=1` | Optional tools (cloudflared, ngrok, d2, marp, blender) |
| `SKIP_LATEX=1` | Skip texlive (~500MB) |
| `SKIP_MEDIA=1` | Skip vlc, ffmpeg, qjackctl |
| `SKIP_BROWSERS=1` | Skip chrome, brave, spotify |

## Scripts

| Script | Purpose |
|--------|---------|
| `bootstrap.sh` | Entry point - clones repo, runs all phases |
| `install-packages.sh` | APT, UV, Cargo, Go, Node, browsers, fonts |
| `link-configs.sh` | Symlinks dotfiles to home |
| `configure-system.sh` | Git config, systemd, greetd |
| `verify.sh` | Post-install verification |

## After Install

1. Reboot
2. `git-credential-manager configure`
3. `rclone config`
4. Import KeePassXC database

## Re-run Individual Phases

```bash
cd ~/.config/new-machine-setup
./install-packages.sh
./verify.sh
```

Logs: `~/bootstrap-<timestamp>.log`
