# Setup Documentation

New machine bootstrapping pipeline. Designed for fresh Ubuntu installations, but all scripts are idempotent and safe to re-run for updates or repairs.

## Contents

| File | Description |
|------|-------------|
| [bootstrap.md](bootstrap.md) | Entry point script that orchestrates the full setup sequence and handles phase selection. |
| [packages.md](packages.md) | Package installation covering APT, Cargo, uv, Go, npm, custom binaries, and fonts. |
| [linking.md](linking.md) | Symlink creation for configs, scripts, and desktop files to their target locations. |
| [system-config.md](system-config.md) | System-level configuration: git, shell, services, power management, default apps, DPI. |
| [verification.md](verification.md) | Post-install verification checks for commands, symlinks, services, and manual steps. |
| [post-install.md](post-install.md) | Manual steps required after automated setup: logins, plugin installs, credential files. |

## Setup Flow

```
bootstrap.sh
    │
    ├── install-packages.sh
    │   ├── APT packages (dev tools, CLI utilities, system packages)
    │   ├── Flatpak apps (Brave, Telegram)
    │   ├── Cargo tools (bat, eza, ripgrep, etc.)
    │   ├── uv tools (ruff, pytest, jupyter, whisper)
    │   ├── Go tools (lazysql, usql, demongrep)
    │   ├── npm packages (claude, n)
    │   └── Custom binaries (lazygit, GCM, d2, neovim)
    │
    ├── link-configs.sh
    │   ├── Shell configs (~/.zshrc, ~/.tmux.conf)
    │   ├── Scripts (~/.local/bin/*)
    │   └── Desktop files (~/.local/share/applications/*)
    │
    ├── configure-system.sh
    │   ├── Git (user, credentials, default branch)
    │   ├── Default shell (zsh)
    │   ├── Services (docker, TLP, NetworkManager)
    │   ├── Power management (TLP thresholds)
    │   ├── Default apps (zathura, nsxiv)
    │   └── DPI scaling (.xsessionrc)
    │
    └── verify.sh
        ├── Command checks
        ├── Symlink validation
        ├── Service status
        └── Reboot requirements
```

## Environment Variables

| Variable | Effect |
|----------|--------|
| `SKIP_LATEX=1` | Skip ~500MB LaTeX package installation |

## Re-running Phases

Each phase can be run independently for repairs or updates:

```bash
# Fix broken symlinks
./new-machine-setup/link-configs.sh

# Install new packages added to script
./new-machine-setup/install-packages.sh

# Reapply system configuration
./new-machine-setup/configure-system.sh

# Check what's missing
./new-machine-setup/verify.sh
```
