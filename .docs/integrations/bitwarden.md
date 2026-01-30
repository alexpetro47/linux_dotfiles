# Bitwarden Integration

Password management via Bitwarden CLI and programmatic secrets via Bitwarden Secrets Manager (bws).

## Bitwarden CLI

### Installation

Installed via `install-packages.sh` (npm package).

### Authentication

```bash
bw login
```

Authenticates and stores session. Prompted for master password.

### Session Management

```bash
bw unlock              # Unlock vault, get session key
bw lock                # Lock vault
bw status              # Check current state
```

Session key needed for most operations. Export to environment:

```bash
export BW_SESSION="..."
```

### Common Commands

```bash
bw sync                # Sync with server
bw list items          # List all items
bw get item "name"     # Get specific item
bw generate -ulns 20   # Generate password
```

### Vault Backup

See [scripts/backup.md](../scripts/backup.md) for backup-bitwarden script.

## Bitwarden Secrets Manager (bws)

Programmatic access to secrets for scripts and applications.

### Setup

1. Create access token in Bitwarden web vault
2. Store in GNOME keyring:

```bash
secret-tool store --label="BWS Access Token" service bws
# Paste token when prompted
```

3. Environment variable in `.zshrc`:

```bash
export BWS_ACCESS_TOKEN="$(secret-tool lookup service bws)"
```

### Aliases

Defined in `zsh/.zshrc`:

| Alias | Command | Purpose |
|-------|---------|---------|
| `bws-get` | `bws secret get` | Get secret by ID |
| `bws-list` | `bws secret list` | List secrets in project |
| `bws-projects` | `bws project list` | List projects |

### Usage

```bash
# List projects
bws-projects

# List secrets in project
bws-list --project-id <project-id>

# Get specific secret
bws-get <secret-id>

# Get secret value only
bws secret get <id> | jq -r .value
```

### In Scripts

```bash
#!/bin/bash
API_KEY=$(bws secret get <id> | jq -r .value)
curl -H "Authorization: Bearer $API_KEY" ...
```

### Creating Secrets

```bash
bws secret create "KEY_NAME" "value" --project-id <project-id>
```

## Project Organization

Organize secrets by project:

```
Projects/
├── personal/
│   ├── GITHUB_TOKEN
│   └── OPENAI_API_KEY
├── work/
│   └── ...
└── claude/
    ├── ANTHROPIC_API_KEY
    └── ...
```

## Security Notes

- Access tokens have limited scope
- Rotate tokens periodically
- Use keyring, not plaintext files
- Different tokens for different machines

## Troubleshooting

**bws command not found:**
```bash
cargo install bws
```

**Token not working:**
```bash
# Check token stored correctly
secret-tool lookup service bws

# Re-store token
secret-tool store --label="BWS Access Token" service bws
```

**Session expired:**
```bash
bw unlock
export BW_SESSION="<new-session>"
```
