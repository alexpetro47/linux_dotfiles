# Neovim

Editor configuration using Lazy.nvim plugin manager with custom keymaps and minimal UI.

## Config Location

`nvim/init.lua`

## Plugin Manager

[Lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

Opens on first launch to install plugins.

## Key Mappings

### Leader Key

```lua
vim.g.mapleader = ' '  -- Space
```

### Mode Exit

| Key | Mode | Action |
|-----|------|--------|
| `jj` | Insert | Escape to normal |

### File Operations

| Key | Action |
|-----|--------|
| `<Leader>w` | Write buffer |
| `<Leader>y` | Copy all to clipboard |
| `<Leader>I` | Move clipboard image to `.media/`, insert markdown |

### Clipboard

| Key | Action |
|-----|--------|
| `P` | Paste from system clipboard |
| `D` (visual) | Delete and yank to clipboard |

### Line Movement

| Key | Mode | Action |
|-----|------|--------|
| `J` | Visual | Move lines down |
| `K` | Visual | Move lines up |

### Word Motion

Custom word motion that skips `_` and `-`:

| Key | Action |
|-----|--------|
| `w` | Forward word (skip separators) |
| `b` | Backward word (skip separators) |
| `e` | End of word (skip separators) |

### Disabled Keys

These keys are disabled/remapped:

| Key | Reason |
|-----|--------|
| `U` | Prevents accidental undo |
| `Y` | Avoid confusion |
| `H`, `L` | Workspace navigation |
| `J`, `K` | Line movement |
| `M` | Unused |
| `gl`, `gn` | Unused |
| `s` | Leap.nvim |

## UI Settings

```lua
vim.opt.number = false        -- No line numbers
vim.opt.signcolumn = 'no'     -- No sign column
vim.opt.wrap = false          -- No line wrap
vim.opt.cursorline = true     -- Highlight current line
```

## Indentation

```lua
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true      -- Spaces, not tabs
```

## Search

```lua
vim.opt.ignorecase = true
vim.opt.smartcase = true      -- Case-sensitive if uppercase
vim.opt.hlsearch = false      -- No persistent highlight
```

## Plugins

Common plugins (varies by setup):

| Plugin | Purpose |
|--------|---------|
| `telescope.nvim` | Fuzzy finder |
| `nvim-treesitter` | Syntax highlighting |
| `nvim-lspconfig` | LSP support |
| `nvim-cmp` | Completion |
| `leap.nvim` | Fast motion |
| `image.nvim` | Image preview (Kitty) |

## Image Support

Requires Kitty terminal for `image.nvim`:

```lua
require('image').setup({
  backend = 'kitty',
})
```

## Adding Keymaps

```lua
vim.keymap.set('n', '<Leader>x', function()
  -- action
end, { desc = 'Description' })
```

Modes:
- `n` - Normal
- `i` - Insert
- `v` - Visual
- `x` - Visual block

## LSP Configuration

Language servers configured per-language. Common ones:

| Server | Language |
|--------|----------|
| `pyright` | Python |
| `rust_analyzer` | Rust |
| `tsserver` | TypeScript |
| `lua_ls` | Lua |

## Commands

| Command | Action |
|---------|--------|
| `:Lazy` | Open plugin manager |
| `:Mason` | LSP/DAP installer |
| `:checkhealth` | Diagnose issues |

## File Types

Automatic detection. Override with:

```vim
:set filetype=python
```

## Troubleshooting

**Plugins not loading:**
```vim
:Lazy
```
Press `I` to install.

**LSP not working:**
```vim
:LspInfo
:LspLog
```

**Check health:**
```vim
:checkhealth
```
