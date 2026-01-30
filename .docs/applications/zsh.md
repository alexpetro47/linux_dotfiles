# Zsh Shell

Shell configuration with zinit plugin manager, custom prompt, vim-style keybindings, and extensive aliases.

## Config Location

- Source: `zsh/.zshrc`
- Symlink: `~/.zshrc`

## Plugin Manager

Uses [zinit](https://github.com/zdharma-continuum/zinit) for plugin management.

### Plugins

| Plugin | Purpose |
|--------|---------|
| `zsh-autosuggestions` | Fish-like suggestions |
| `zsh-syntax-highlighting` | Syntax colors |
| `fzf` | Fuzzy finder integration |
| `zoxide` | Smart directory jumping |
| `history-substring-search` | History search |

## Keybindings

### Navigation

| Key | Action |
|-----|--------|
| `Ctrl+r` | fzf history search |
| `Ctrl+f` | Forward word |
| `Ctrl+b` | Backward word |
| `jj` | Escape (vi mode) |

### Editing

| Key | Action |
|-----|--------|
| `Ctrl+a` | Beginning of line |
| `Ctrl+e` | End of line |
| `Ctrl+w` | Delete word backward |
| `Ctrl+u` | Delete line |

## Prompt

Minimal prompt showing only essential info:

```
❯   # Green if last command succeeded
❯   # Red if last command failed
```

Directory shown in window title, not prompt.

## History

```bash
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history
```

Options:
- `SHARE_HISTORY` - Share across sessions
- `HIST_IGNORE_DUPS` - Skip duplicates
- `HIST_VERIFY` - Verify history expansion

## Aliases

### Navigation

| Alias | Command |
|-------|---------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `-` | `cd -` |

### Listing

| Alias | Command |
|-------|---------|
| `ls` | `eza` |
| `ll` | `eza -la` |
| `lt` | `eza --tree` |

### Git

| Alias | Command |
|-------|---------|
| `g` | `git` |
| `gs` | `git status` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `lg` | `lazygit` |

### Tools

| Alias | Command |
|-------|---------|
| `cat` | `bat` |
| `vim` | `nvim` |

### Remote Access

| Alias | Command |
|-------|---------|
| `pc` | `ssh alexpetro@alexpetro-um890pro` |
| `pcsync` | Sync to mini PC |

### Bitwarden Secrets

| Alias | Command |
|-------|---------|
| `bws-get` | Get secret by ID |
| `bws-list` | List secrets in project |
| `bws-projects` | List projects |

## Environment Variables

### Path

```bash
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"
```

### Tools

```bash
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
```

### Secrets

API keys sourced from `~/.claude/.env`:

```bash
[ -f ~/.claude/.env ] && source ~/.claude/.env
```

### Bitwarden Secrets Manager

```bash
export BWS_ACCESS_TOKEN="$(secret-tool lookup service bws)"
```

Stored in GNOME keyring via:
```bash
secret-tool store --label="BWS Access Token" service bws
```

## fzf Configuration

```bash
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
```

## Zoxide

Smart `cd` replacement:

```bash
z dir      # Jump to directory matching "dir"
zi dir     # Interactive selection
```

## Custom Functions

Add functions directly in `.zshrc`:

```bash
function my-function() {
    # commands
}
```

## Adding Aliases

Add to `zsh/.zshrc`:

```bash
alias myalias='my-command'
```

Then reload:

```bash
source ~/.zshrc
# or just open new terminal
```
