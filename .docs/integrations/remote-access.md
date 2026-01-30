# Remote Access

SSH access to mini PC (UM890PRO) for ralph daemon, kgraph, and compute tasks.

## Mini PC Details

| Property | Value |
|----------|-------|
| Model | UM890PRO |
| Hostname | `alexpetro-um890pro` |
| User | `alexpetro` |
| Purpose | Ralph daemon, kgraph, training |

## SSH Connection

```bash
ssh alexpetro@alexpetro-um890pro
```

Alias defined in `.zshrc`:

```bash
alias pc='ssh alexpetro@alexpetro-um890pro'
```

## File Sync

`pcsync` alias for syncing files:

```bash
pcsync /local/path remote/path
```

Prefer git push/pull for code sync. Use scp/rsync for data.

## Services on Mini PC

| Service | Purpose |
|---------|---------|
| Ralph daemon | AI agent background process |
| Kgraph | Knowledge graph source of truth |
| Training | ML model fine-tuning |

## SSH Key Setup

If not already configured:

```bash
# Generate key (if needed)
ssh-keygen -t ed25519 -C "your-email@example.com"

# Copy to remote
ssh-copy-id alexpetro@alexpetro-um890pro
```

## SSH Config

Optional `~/.ssh/config` entry:

```
Host pc
    HostName alexpetro-um890pro
    User alexpetro
    IdentityFile ~/.ssh/id_ed25519
```

Then just:
```bash
ssh pc
```

## Tailscale (Optional)

For access outside local network:

```bash
# Install on both machines
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# Connect via Tailscale IP
ssh alexpetro@100.x.x.x
```

See `additional-installs.md` for Tailscale setup.

## Port Forwarding

Forward remote port to local:

```bash
ssh -L 8080:localhost:8080 alexpetro@alexpetro-um890pro
```

Useful for:
- Jupyter notebooks
- Web UIs
- Database connections

## Common Tasks

### Check Ralph Status

```bash
pc
systemctl status ralph
```

### Sync Kgraph

```bash
pc
# On remote:
brain workspace export -o /tmp/kgraph-export.json
# Then scp back
```

### Run Training

```bash
pc
cd ~/training
./run-training.sh
```

## Troubleshooting

**Connection refused:**
```bash
# Check SSH is running on remote
ssh alexpetro@alexpetro-um890pro "systemctl status sshd"
```

**Key not accepted:**
```bash
# Verbose mode
ssh -v alexpetro@alexpetro-um890pro

# Check authorized_keys on remote
cat ~/.ssh/authorized_keys
```

**Host not found:**
```bash
# Check if on same network
ping alexpetro-um890pro

# Use IP directly
ssh alexpetro@192.168.x.x
```
