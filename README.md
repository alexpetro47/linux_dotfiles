# New Machine Setup

Automated dotfiles bootstrap for fresh Ubuntu. Idempotent - safe to re-run.

## Quick Start

```bash
# Full install
curl -fsSL https://raw.githubusercontent.com/justatoaster47/linux_dotfiles/main/new-machine-setup/bootstrap.sh | bash

# Minimal (skip LaTeX)
curl -fsSL ... | SKIP_LATEX=1 bash

# With extras (cloudflared, ngrok, d2, blender, etc.)
curl -fsSL ... | INSTALL_EXTRAS=1 bash
```

## Flags

| Flag | Effect |
|------|--------|
| `SKIP_LATEX=1` | Skip texlive (~500MB) |
| `INSTALL_EXTRAS=1` | Optional tools (cloudflared, ngrok, d2, marp, blender, lazysql, usql) |

## Scripts

| Script | Purpose |
|--------|---------|
| `bootstrap.sh` | Entry point - clones repo, runs all phases |
| `install-packages.sh` | APT, UV, Cargo, Go, Node, browsers, fonts |
| `link-configs.sh` | Symlinks dotfiles to home |
| `configure-system.sh` | Git config, systemd, defaults |
| `verify.sh` | Post-install verification |

## After Install

1. Reboot
2. `git-credential-manager configure`
3. `rclone config`
4. Import KeePassXC database
5. Brave: sync account, theme=gtk

## Re-run Individual Phases

```bash
cd ~/.config/new-machine-setup
./install-packages.sh
./verify.sh
```

Logs: `~/bootstrap-<timestamp>.log`

---

## Extras

### go
```bash
go install github.com/jorgerojas26/lazysql@latest  # lazysql
go install github.com/xo/usql@latest               # usql
```

### npm
```bash
npm i -g @marp-team/marp-cli  # marp
```

### apt
```bash
# cloudflared
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared jammy main' | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt update && sudo apt install -y cloudflared

# ngrok
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update && sudo apt install -y ngrok

# azure-cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### curl
```bash
# d2
curl -fsSL https://d2lang.com/install.sh | sh

# drawio
curl -fLo ~/.local/bin/drawio "https://github.com/jgraph/drawio-desktop/releases/download/v28.0.6/drawio-x86_64-28.0.6.AppImage" && chmod +x ~/.local/bin/drawio

# blender
curl -L https://download.blender.org/release/Blender4.2/blender-4.2.1-linux-x64.tar.xz | tar -xJ -C ~/.local
ln -sf ~/.local/blender-4.2.1-linux-x64/blender ~/.local/bin/blender

# sqlite-vec
mkdir -p ~/.local/lib
curl -L https://github.com/asg017/sqlite-vec/releases/download/v0.1.3/sqlite-vec-0.1.3-loadable-linux-x86_64.tar.gz | tar -xz -C ~/.local/lib
```

### docker
```bash
docker run -p 7474:7474 -p 7687:7687 -e NEO4J_AUTH=neo4j/password neo4j  # neo4j
```

### manual
- **reaper**: https://www.reaper.fm/download.php
- **dbgate**: https://dbgate.org/download/
