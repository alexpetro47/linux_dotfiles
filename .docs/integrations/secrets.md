# Secrets Management

Patterns for storing and accessing sensitive credentials.

## Storage Locations

| Type | Location | Access |
|------|----------|--------|
| API keys | `~/.claude/.env` | Source in shell |
| BWS token | GNOME keyring | `secret-tool` |
| Passwords | Bitwarden | `bw` CLI |
| SSH keys | `~/.ssh/` | Direct file |
| rclone tokens | `~/.config/rclone/rclone.conf` | rclone manages |

## Environment File

`~/.claude/.env` for API keys:

```bash
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
GITHUB_TOKEN=ghp_...
```

Sourced in `.zshrc`:

```bash
[ -f ~/.claude/.env ] && source ~/.claude/.env
```

**Security:**
- Not tracked in git (in `.gitignore`)
- `chmod 600 ~/.claude/.env`
- Don't commit to any repo

## GNOME Keyring

For secrets needed by scripts:

### Store

```bash
secret-tool store --label="Description" service servicename
# Enter value when prompted
```

### Retrieve

```bash
secret-tool lookup service servicename
```

### In Scripts

```bash
MY_SECRET=$(secret-tool lookup service myservice)
```

### Current Keyring Usage

| Service | Purpose |
|---------|---------|
| `bws` | Bitwarden Secrets Manager token |

## Bitwarden Secrets Manager

For programmatic secret access:

```bash
# List secrets
bws-list --project-id <id>

# Get secret
bws secret get <id> | jq -r .value
```

See [bitwarden.md](bitwarden.md) for setup.

## Best Practices

### Never Commit Secrets

- Check `.gitignore` covers secret files
- Use `git secrets` or pre-commit hooks
- Review diffs before committing

### Use Appropriate Storage

| Secret Type | Storage |
|-------------|---------|
| API keys (scripts) | `~/.claude/.env` |
| API keys (programmatic) | Bitwarden Secrets |
| Passwords | Bitwarden |
| Access tokens | GNOME keyring |
| SSH keys | `~/.ssh/` |

### Rotate Regularly

- API keys: Quarterly or on compromise
- Access tokens: Monthly
- Passwords: Annually minimum

### Scope Appropriately

- Use minimal permissions
- Separate tokens per machine/use case
- Revoke unused tokens

## Adding New Secrets

### For Shell Scripts

1. Add to `~/.claude/.env`:
   ```bash
   NEW_API_KEY=value
   ```

2. Use in scripts:
   ```bash
   curl -H "Authorization: Bearer $NEW_API_KEY" ...
   ```

### For Background Services

1. Store in keyring:
   ```bash
   secret-tool store --label="New Service" service newservice
   ```

2. Retrieve in service:
   ```bash
   TOKEN=$(secret-tool lookup service newservice)
   ```

### For Bitwarden Secrets

1. Create in web vault under Secrets Manager
2. Note the secret ID
3. Access:
   ```bash
   bws secret get <id> | jq -r .value
   ```

## Troubleshooting

**Environment variable not set:**
```bash
# Check if sourced
echo $ANTHROPIC_API_KEY

# Manually source
source ~/.claude/.env
```

**Keyring locked:**
```bash
# Unlock
gnome-keyring-daemon --unlock
```

**BWS token invalid:**
```bash
# Re-store token
secret-tool store --label="BWS Access Token" service bws
```
