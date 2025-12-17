See `README.md` for setup instructions.

## Config Changes

| Change | Where |
|--------|-------|
| APT package | `install-packages.sh` → apt block |
| UV/Cargo/Go tool | `install-packages.sh` → respective section |
| Custom binary | `install-packages.sh` → `if ! installed` block |
| New config file | `.gitignore` whitelist + `link-configs.sh` symlink |
| Tool substitution | install script + `.zshrc` aliases |
| Optional tool | `README.md` → Extras section |

## Idempotency Pattern

```bash
if ! installed <cmd>; then
    log "Installing <pkg>..."
    # install commands
else
    log "<pkg> already installed"
fi
```

## Keybindings

| Key | Action |
|-----|--------|
| `Alt+Shift+t` | Toggle theme (dark/light) |
| `Alt+Shift+s` | Toggle focus mode (notifications) |
| `Alt+Shift+b` | Toggle polybar |

## Theme

- `tinty apply <scheme>` - apply any base16 scheme
- `tinty list | grep <name>` - find schemes
- Config: `~/.config/theme-schemes` (dark/light toggle preferences)




