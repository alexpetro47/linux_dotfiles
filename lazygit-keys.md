# Lazygit Keybindings

Access: `C-w g` (tmux)

## Navigation
| Key | Action |
|-----|--------|
| `h/l` | Switch panels (left/right) |
| `j/k` | Navigate items (down/up) |
| `[/]` | Switch tabs within panel |
| `?` | Show all keybindings |
| `q` | Quit |

## Files Panel (1)
| Key | Action |
|-----|--------|
| `space` | Stage/unstage file |
| `a` | Stage all files |
| `d` | Discard changes (unstaged) |
| `D` | Discard options menu |
| `e` | Edit file |
| `o` | Open file in default app |
| `i` | Add to .gitignore |

## Staging (enter on file)
| Key | Action |
|-----|--------|
| `space` | Stage/unstage hunk |
| `v` | Visual select lines |
| `a` | Stage/unstage all hunks |
| `esc` | Return to files |

## Commits Panel (2)
| Key | Action |
|-----|--------|
| `c` | Commit staged |
| `A` | Amend last commit |
| `r` | Reword commit message |
| `s` | Squash into previous |
| `f` | Fixup into previous |
| `d` | Drop commit |
| `e` | Edit commit (interactive rebase) |
| `p` | Pick commit (during rebase) |
| `g` | Reset to commit (soft/mixed/hard menu) |
| `C` | Copy commit (cherry-pick) |
| `V` | Paste commit (apply cherry-pick) |

## Branches Panel (3)
| Key | Action |
|-----|--------|
| `space` | Checkout branch |
| `n` | New branch |
| `d` | Delete branch |
| `M` | Merge into current |
| `r` | Rebase current onto selected |
| `R` | Rename branch |
| `u` | Set upstream |

## Stash Panel (4)
| Key | Action |
|-----|--------|
| `space` | Apply stash |
| `g` | Pop stash |
| `d` | Drop stash |
| `n` | New stash |

## Remote/Push/Pull
| Key | Action |
|-----|--------|
| `p` | Pull |
| `P` | Push |
| `f` | Fetch |
| `F` | Force push |

## Search & Filter
| Key | Action |
|-----|--------|
| `/` | Filter current panel |
| `ctrl+s` | Search commits |

## Other
| Key | Action |
|-----|--------|
| `z` | Undo (reflog) |
| `ctrl+z` | Redo |
| `+` | Expand diff context |
| `-` | Collapse diff context |
| `W` | Show diff options |
| `@` | Open command log |
