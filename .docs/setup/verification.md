# Verification

Post-install verification script that checks all critical components are installed and configured correctly.

## Location

`new-machine-setup/verify.sh`

## Usage

```bash
./new-machine-setup/verify.sh
```

## Checks Performed

### Command Availability

Verifies these commands exist in PATH:

| Category | Commands |
|----------|----------|
| Shell | `zsh` |
| Editor | `nvim` |
| Package managers | `uv`, `cargo`, `go`, `npm`, `bun` |
| Window manager | `i3`, `polybar`, `rofi`, `dunst` |
| Utilities | `fzf`, `rg`, `fd`, `bat`, `eza`, `zoxide` |
| Git | `git`, `gh`, `lazygit` |
| Media | `ffmpeg`, `convert`, `zathura` |
| Containers | `docker` |

### Symlink Validation

Checks that required symlinks exist and point to correct targets:

| Symlink | Target |
|---------|--------|
| `~/.zshrc` | `~/.config/zsh/.zshrc` |
| `~/.tmux.conf` | `~/.config/tmux/tmux.conf` |
| `~/.local/bin/toggle-theme` | Script in repo |
| `~/.local/bin/backup` | Script in repo |

### Service Status

Verifies systemd services are enabled and running:

- `docker.service`
- `tlp.service`
- `NetworkManager.service`

### Group Membership

Checks user is in required groups:

- `docker` - For rootless container access

## Output Format

```
[OK] Command: zsh
[OK] Command: nvim
[WARN] Command: missing-tool - Not installed
[OK] Symlink: ~/.zshrc
[OK] Service: docker
[WARN] Group: docker - Requires logout to take effect
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All checks passed |
| 1 | Some checks failed (warnings count as pass) |

## Reboot Requirements

The script flags items requiring reboot or re-login:

- Shell change (zsh) - Requires logout
- Docker group - Requires logout
- TLP configuration - Requires reboot for full effect

## Post-Verification

After `verify.sh` passes, complete manual steps in [post-install.md](post-install.md).
