- fresh ubuntu → full rig:
  ```bash
  sudo apt update && sudo apt install -y curl && curl -fsSL https://raw.githubusercontent.com/justatoaster47/linux_dotfiles/main/new-machine-setup/bootstrap.sh | bash
  ```

- on installation of new packages / libs / tools /
applications, update @installs.md in apropriate section
(e.g. apt / bun / cargo / uv) or create new entry (e.g. curl
download)

- on creation of new config files or scripts, add to
@.gitignore with alternating whitelist pattern s.t. its
tracked by git (e.g. `!installs.md` for installs.md doc)

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

- installs.md structure:
  - everything above `# EXTRAS` = standard installation (automated via install-packages.sh)
  - everything at/below `# EXTRAS` = optional/personal notes (requires `INSTALL_EXTRAS=1` or manual steps)

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




