# Package Installation

Installs all required packages across multiple package managers. Handles APT, Flatpak, Cargo, uv, Go, npm, and custom binaries.

## Location

`new-machine-setup/install-packages.sh`

## Package Categories

### APT Packages

**Development Tools**
- `build-essential`, `cmake`, `pkg-config` - C/C++ compilation
- `python3-dev`, `python3-venv` - Python development
- `sqlite3`, `libsqlite3-dev` - Database
- `git`, `gh` - Version control

**CLI Utilities**
- `fzf`, `fd-find`, `jq`, `yq` - Search and parsing
- `curl`, `wget`, `httpie` - HTTP clients
- `htop`, `btop`, `ncdu` - System monitoring
- `tree`, `xclip`, `xdotool` - System utilities

**Window Manager & UI**
- `i3`, `polybar`, `rofi`, `dunst` - Desktop environment
- `picom` - Compositor
- `feh`, `nsxiv` - Image viewers
- `flameshot` - Screenshot tool

**Media**
- `ffmpeg`, `imagemagick`, `pandoc` - Processing
- `sox`, `pulseaudio-utils` - Audio
- `zathura`, `zathura-pdf-poppler` - PDF viewing

**Fonts**
- JetBrainsMono Nerd Font (downloaded from GitHub releases)

### Flatpak Apps

- **Brave Browser** - `com.brave.Browser`
- **Telegram Desktop** - `org.telegram.desktop`

### Cargo (Rust) Tools

| Tool | Purpose |
|------|---------|
| `bat` | Syntax-highlighted cat |
| `eza` | Modern ls replacement |
| `ripgrep` | Fast grep |
| `zoxide` | Smart cd |
| `starship` | Shell prompt |
| `tinty` | Base16 color manager |
| `tokei` | Code statistics |

### uv (Python) Tools

| Tool | Purpose |
|------|---------|
| `ruff` | Linter/formatter |
| `pytest`, `pytest-cov` | Testing |
| `mypy` | Type checking |
| `bandit` | Security linting |
| `jupyter`, `jupyterlab` | Notebooks |
| `whisper-ctranslate2` | Speech transcription |
| `rclip` | Semantic image search |
| `pre-commit` | Git hooks |

### Go Tools

| Tool | Purpose |
|------|---------|
| `lazysql` | Database TUI |
| `usql` | Universal SQL client |
| `demongrep` | Semantic code search |

### npm Packages

| Package | Purpose |
|---------|---------|
| `@anthropic-ai/claude-code` | Claude CLI |
| `n` | Node version manager |

### Custom Binaries

Downloaded and installed to `~/.local/bin/` or `/usr/local/bin/`:

| Binary | Source | Purpose |
|--------|--------|---------|
| `lazygit` | GitHub releases | Git TUI |
| `git-credential-manager` | GitHub releases | Git auth |
| `d2` | GitHub releases | Diagram language |
| `nvim` | Built from source | Editor |
| `bun` | Official installer | JS runtime |
| `uv` | Official installer | Python package manager |

## Custom Binary Pattern

Each custom binary uses an idempotent installation check:

```bash
if ! installed lazygit; then
    # Download and install
fi
```

This ensures:
- Skips if already installed
- Can be re-run safely
- Easy to add new binaries

## Neovim Build

Built from source for latest features:

```bash
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
```

## Skipping LaTeX

LaTeX packages (~500MB) can be skipped:

```bash
SKIP_LATEX=1 ./install-packages.sh
```

## Adding New Packages

| Type | Location in script |
|------|-------------------|
| APT package | `apt install` block |
| Cargo tool | `cargo install` block |
| uv tool | `uv tool install` block |
| Go tool | `go install` block |
| Custom binary | Add `if ! installed` block |
