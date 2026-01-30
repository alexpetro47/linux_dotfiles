# Applications Documentation

Per-application configuration reference. Each file documents the config structure, key customizations, and usage patterns.

## Contents

| File | Description |
|------|-------------|
| [i3.md](i3.md) | Window manager configuration: keybindings, workspaces, window rules, startup applications. |
| [polybar.md](polybar.md) | Status bar modules: IPC controls, system monitors, theming integration. |
| [zsh.md](zsh.md) | Shell configuration: plugins, aliases, keybindings, prompt, environment setup. |
| [tmux.md](tmux.md) | Terminal multiplexer: prefix key, pane navigation, plugins, status line. |
| [neovim.md](neovim.md) | Editor configuration: Lazy.nvim plugins, custom keymaps, language support. |
| [terminals.md](terminals.md) | Alacritty and Kitty terminal emulator settings: fonts, colors, keybindings. |
| [utilities.md](utilities.md) | Supporting tools: rofi, dunst, zathura, flameshot, lazygit. |

## Config Locations

Most configs live in `~/.config/<app>/` and are tracked in this repository.

| Application | Config Path | Notes |
|-------------|-------------|-------|
| i3 | `i3/config` | Main config |
| Polybar | `polybar/config.ini` | Bar config |
| Zsh | `zsh/.zshrc` | Symlinked to `~/.zshrc` |
| Tmux | `tmux/tmux.conf` | Symlinked to `~/.tmux.conf` |
| Neovim | `nvim/init.lua` | Lua config |
| Alacritty | `alacritty/alacritty.toml` | TOML config |
| Kitty | `kitty/kitty.conf` | For image support |
| Rofi | `rofi/config.rasi` | App launcher |
| Dunst | `dunst/dunstrc` | Notifications |
| Zathura | `zathura/zathurarc` | PDF viewer |

## Theming

Applications that support base16 theming via tinty:
- i3 (colors in config)
- Polybar (colors.ini)
- Alacritty (colors.toml)
- Tmux (colors.conf)
- Zathura (zathurarc)

See [features/theming.md](../features/theming.md) for details.

## Customization Patterns

### Adding Keybindings

| App | Location | Format |
|-----|----------|--------|
| i3 | `i3/config` | `bindsym $mod+key exec command` |
| Zsh | `zsh/.zshrc` | `bindkey '^X' widget` |
| Tmux | `tmux/tmux.conf` | `bind key command` |
| Neovim | `nvim/init.lua` | `vim.keymap.set('n', '<key>', action)` |

### Adding Aliases

Zsh aliases in `zsh/.zshrc`:
```bash
alias name='command'
```

### Adding Environment Variables

In `zsh/.zshrc` or `~/.claude/.env` for secrets.
