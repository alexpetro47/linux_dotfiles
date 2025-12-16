
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

  # run phases individually (after clone)
  cd ~/.config/new-machine-setup
  ./install-packages.sh   # apt, uv, cargo, npm, browsers
  ./link-configs.sh       # symlinks (~/.zshrc, etc)
  ./configure-system.sh   # git config, systemctl, greetd
  ```
  - logs to `~/bootstrap-*.log`
  - idempotent (safe to re-run)
  - manual after: reboot, git-credential-manager, rclone config, keepassxc

