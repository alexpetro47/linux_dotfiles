# Terminal Emulators

Configuration for Alacritty (primary) and Kitty (for image support in Neovim).

## Alacritty

Primary terminal emulator. Fast GPU-accelerated rendering.

### Config Location

`alacritty/alacritty.toml`

### Colors

Managed by tinty:

```toml
import = ["~/.config/alacritty/colors.toml"]
```

Updates automatically with `toggle-theme`.

### Font

```toml
[font]
size = 14

[font.normal]
family = "JetBrainsMono Nerd Font"
style = "Regular"
```

### Window

```toml
[window]
padding.x = 10
padding.y = 10
decorations = "none"
opacity = 1.0
```

### Scrolling

```toml
[scrolling]
history = 10000
multiplier = 3
```

### Keybindings

Custom bindings in `[keyboard.bindings]`:

| Key | Action |
|-----|--------|
| `Ctrl+Shift+c` | Copy |
| `Ctrl+Shift+v` | Paste |
| `Ctrl+Shift+plus` | Increase font |
| `Ctrl+Shift+minus` | Decrease font |

### Launching

Opened by i3 with `Mod+Return`:

```
bindsym $mod+Return exec alacritty
```

## Kitty

Secondary terminal. Used when image preview is needed (Neovim image.nvim plugin).

### Config Location

`kitty/kitty.conf`

### Image Protocol

Kitty has native image rendering protocol used by:
- `image.nvim` (Neovim)
- `ranger` file manager
- `viu` image viewer

### Font

```
font_family JetBrainsMono Nerd Font
font_size 14.0
```

### Window

```
window_padding_width 10
hide_window_decorations yes
```

### When to Use Kitty

Use Kitty instead of Alacritty when:
- Viewing images in Neovim
- Using image-aware file managers
- Need inline image display

Launch with:
```bash
kitty
```

## Comparison

| Feature | Alacritty | Kitty |
|---------|-----------|-------|
| Speed | Fastest | Fast |
| Images | No | Yes |
| GPU | Yes | Yes |
| Config | TOML | Custom |
| Complexity | Minimal | Feature-rich |

## Switching Default Terminal

Edit i3 config:

```
# For Alacritty
bindsym $mod+Return exec alacritty

# For Kitty
bindsym $mod+Return exec kitty
```

## True Color Support

Both support 24-bit color. Verify with:

```bash
curl -s https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash
```

## Font Ligatures

JetBrainsMono Nerd Font includes ligatures for:
- `->` `=>` `!=` `==` `<=` `>=`
- `/*` `*/` `//` `##`
- And more programming symbols

Enabled by default in both terminals.
