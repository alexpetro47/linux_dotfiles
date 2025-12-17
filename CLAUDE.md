- fresh ubuntu → full rig:
  ```bash
  sudo apt update && sudo apt install -y curl && curl -fsSL https://raw.githubusercontent.com/justatoaster47/linux_dotfiles/main/new-machine-setup/bootstrap.sh | bash
  ```

- on config changes, update the appropriate file:
  - **new package**: add to `install-packages.sh` (idempotent pattern)
  - **new config file**: add whitelist entry to `.gitignore`, add symlink to `link-configs.sh`
  - **substituting tool**: update install script, aliases in `.zshrc`, any referencing configs

- new machine setup:
  ```bash
  # full auto (i3-gaps default)
  curl -fsSL https://raw.githubusercontent.com/justatoaster47/linux_dotfiles/main/new-machine-setup/bootstrap.sh | bash

  # with standard i3
  curl -fsSL ... | INSTALL_I3_GAPS=0 bash

  # with optional extras (cloudflared, ngrok, d2, marp, sqlite-vec, blender)
  curl -fsSL ... | INSTALL_EXTRAS=1 bash

  # minimal install (skip latex ~500MB, media, browsers)
  curl -fsSL ... | SKIP_LATEX=1 SKIP_MEDIA=1 SKIP_BROWSERS=1 bash

  # run phases individually (after clone)
  cd ~/.config/new-machine-setup
  ./install-packages.sh   # apt, uv, cargo, npm, browsers
  ./link-configs.sh       # symlinks (~/.zshrc, etc)
  ./configure-system.sh   # git config, systemctl, greetd
  ./verify.sh             # check installation status
  ```
  - logs to `~/bootstrap-*.log`
  - idempotent (safe to re-run)
  - verify.sh: auto-runs at end, re-run after reboot for full verification
  - manual after: reboot, git-credential-manager, rclone config, keepassxc

## Package & Config Change Workflow

| Change Type | Where to Update |
|-------------|-----------------|
| APT package | `install-packages.sh` → apt block |
| UV/Cargo/Go tool | `install-packages.sh` → respective section |
| Custom binary | `install-packages.sh` → new `if ! installed` block |
| Claude MCP/plugin | `install-packages.sh` → claude section |
| New config file | `.gitignore` whitelist + `link-configs.sh` symlink |
| Tool substitution | install script + `.zshrc` aliases + referencing configs |
| Optional/large tool | `install-packages.sh` EXTRAS section with `INSTALL_EXTRAS` guard |

**Flags** (env vars before running `install-packages.sh`):
- `INSTALL_EXTRAS=1` - cloudflared, ngrok, d2, marp, sqlite-vec, blender, lazysql, usql
- `SKIP_LATEX=1` - skip ~500MB texlive
- `SKIP_MEDIA=1` - skip vlc, ffmpeg, qjackctl, openshot
- `SKIP_BROWSERS=1` - skip chrome, brave, spotify

**Idempotency pattern** (for custom installs):
```bash
if ! installed <cmd>; then
    log "Installing <pkg>..."
    # install commands
else
    log "<pkg> already installed"
fi
```

- theme system (gruvbox dark/light):
  - `Alt+Shift+t` toggles between dark and light mode
  - affects: alacritty, polybar, tmux (unified gruvbox palette)
  - picom: enabled in dark mode (transparency), disabled in light mode (solid bg)
  - state tracked in `~/.config/theme-mode`
  - files:
    - `alacritty/themes/gruvbox-{dark,light}.toml`
    - `polybar/colors-{dark,light}.ini`
    - tmux uses `tmux-gruvbox` plugin (already installed)

- alacritty config notes:
  - `[general]` section required for `import` statement (alacritty 0.13+)
  - without it: "Unused config key: general" warning

- focus mode (manual setup):
  - script: `~/.config/new-machine-setup/focus-toggle`
  - setup: `ln -s ~/.config/new-machine-setup/focus-toggle ~/.local/bin/focus-toggle`
  - i3 binding: `bindsym $mod+z exec --no-startup-id ~/.local/bin/focus-toggle`
  - toggles dunst notifications, state tracked in `~/.config/focus-mode`

---

i'm trying to think of how to optimize the pleasantness of
my developer ux, integration of claude code + tmux + i3,
aesthetic cohesion and niecities, etc. and well architected
in terms of overall workflow and flow state on single screen
laptop, optimized for space




