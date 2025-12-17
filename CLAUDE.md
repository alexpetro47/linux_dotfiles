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

## Adding New Packages

**Principle**: installs.md is documentation/reference, install-packages.sh is automation. Keep them in sync.

| Package Type | Where to Add in install-packages.sh | installs.md Section |
|--------------|-------------------------------------|---------------------|
| APT package | `sudo apt install -y` block (lines ~37-74) | `## APT` |
| UV tool | `uv tool install <pkg>` block (lines ~147-151) | `## UV` |
| Cargo tool | `cargo binstall -y ... <pkg>` line (~173) | `## RUST/CARGO/BINSTALL` |
| Go tool | Add `go install <pkg>@latest` in EXTRAS | `## EXTRAS > TUI alternative` |
| Custom curl/binary | New `if ! installed <cmd>` section | New `## SECTION` |
| Claude MCP server | `claude mcp add` block (lines ~301-304) | `## CLAUDE CODE` |
| Claude plugin | `npx claude-plugins` block (line ~307) | `## CLAUDE CODE` |
| Optional/large tool | Add to EXTRAS section with `INSTALL_EXTRAS` guard | `# EXTRAS` section |

**Flags** (set before running `install-packages.sh`):
- `INSTALL_EXTRAS=1` - include cloudflared, ngrok, d2, marp, sqlite-vec, blender, draw.io, lazysql, usql
- `SKIP_LATEX=1` - skip ~500MB texlive packages
- `SKIP_MEDIA=1` - skip vlc, ffmpeg, qjackctl, openshot, simplescreenrecorder
- `SKIP_BROWSERS=1` - skip chrome, brave, spotify

**Idempotency pattern**:
```bash
if ! installed <cmd>; then
    log "Installing <pkg>..."
    # install commands
else
    log "<pkg> already installed"
fi
```

**Workflow**:
1. Add to install-packages.sh using pattern above
2. Add corresponding entry to installs.md (same section)
3. Test: `./install-packages.sh` (idempotent, safe to re-run)
4. Commit both files together

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




