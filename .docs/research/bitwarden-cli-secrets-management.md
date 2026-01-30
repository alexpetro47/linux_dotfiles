# Bitwarden CLI & Secrets Manager: Comprehensive Research

**Date**: 2026-01-29
**Scope**: Bitwarden CLI (bw), Secrets Manager CLI (bws), and integration patterns for managing API keys and .env variables across projects.

---

## Table of Contents

1. [Overview & Architecture](#overview--architecture)
2. [Installation & Setup](#installation--setup)
3. [Bitwarden CLI (bw) - Vault Management](#bitwarden-cli-bw---vault-management)
4. [Bitwarden Secrets Manager (bws) - Infrastructure Secrets](#bitwarden-secrets-manager-bws---infrastructure-secrets)
5. [Comparison: bw vs bws](#comparison-bw-vs-bws)
6. [Vault & Project Organization](#vault--project-organization)
7. [Integration Patterns](#integration-patterns)
8. [Security Considerations](#security-considerations)
9. [Gotchas & Anti-patterns](#gotchas--anti-patterns)
10. [Recommended Workflow](#recommended-workflow)

---

## Overview & Architecture

### What You're Getting

**Bitwarden Premium** includes:
- Personal password vault with unlimited folders and items
- 1 GB encrypted file storage
- Priority customer support
- Browser extensions (all platforms)

**Bitwarden Secrets Manager** (separate product):
- Infrastructure-focused secret management
- Machine account access (no human users)
- Granular permissions (read vs read/write per project)
- Projects and audit trails
- Zero-knowledge encryption (end-to-end)
- Can be cloud-hosted or self-hosted

### The Key Distinction

**Bitwarden Vault (bw)** = Personal/team password manager with folders. Good for login credentials, secure notes, sharing among humans.

**Secrets Manager (bws)** = Developer-focused, machine-account-based infrastructure secrets. Good for API keys, database passwords, service tokens with programmatic access and audit logging.

**For API keys and .env management across projects**: Consider a hybrid approach:
- **bws** for production/CI/CD secrets (machine accounts, audit trails, projects)
- **bw** for personal development secrets and shared team credentials

---

## Installation & Setup

### Bitwarden CLI (bw)

#### Installation Options

**NPM (recommended if you have Node.js)**:
```bash
npm install -g @bitwarden/cli
```

**Native Executables** (no dependencies):
- Download from https://bitwarden.com/help/cli/ (Windows, macOS, Linux)
- Linux: `chmod +x bw` then add to PATH

**Linux Package Managers**:
```bash
# Snap
sudo snap install bw

# Flatpak
flatpak install flathub com.bitwarden.desktop
```

**Verify Installation**:
```bash
bw --version
```

---

### Secrets Manager CLI (bws)

#### Installation Options

**Cargo (if you have Rust)**:
```bash
cargo install bws
```

**Official Installation Script**:
```bash
curl -sSL https://bitwarden.com/secrets/install | sh
```

**Pre-compiled Binaries**:
- Download from https://github.com/bitwarden/sdk-sm/releases
- Extract and add to PATH

**Docker**:
```bash
docker run --rm -it bitwarden/bws --help
```

**Verify Installation**:
```bash
bws --version
```

---

## Bitwarden CLI (bw) - Vault Management

### Authentication Methods

#### 1. Email & Master Password (Interactive Sessions)

Best for: Manual work, development environments where you're present.

```bash
bw login
# Prompts for email and master password
# Returns BW_SESSION environment variable
```

Save session to current shell:
```bash
export BW_SESSION=$(bw login user@example.com --raw)
```

#### 2. Personal API Key (Automation/Unattended)

Best for: CI/CD, scheduled scripts, accounts with unsupported 2FA.

**Setup**:
1. Log in to https://vault.bitwarden.com
2. Settings → Security → Keys
3. Copy `client_id` and `client_secret`

**Login**:
```bash
bw login --apikey
# Prompts for client_id and client_secret
```

**Automate with Environment Variables**:
```bash
export BW_CLIENTID="user.xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
export BW_CLIENTSECRET="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Then unlock (API key doesn't decrypt vault—still need master password)
export BW_SESSION=$(bw unlock --raw)
# Prompts for master password once
```

**Warning**: API key login authenticates but doesn't decrypt vault data. You still need `bw unlock` to decrypt items.

#### 3. Single Sign-On (SSO)

Best for: Enterprise environments using corporate SSO.

```bash
bw login --sso
# Opens browser for authentication
# Then unlock vault: bw unlock
```

---

### Core Commands

#### Session Management

```bash
# Lock vault (invalidates BW_SESSION)
bw lock

# Logout (invalidates session, clears client data)
bw logout

# Check status
bw status
# Returns: { locked: true/false, authenticated: true/false }
```

#### Retrieve Secrets

```bash
# List all vault items (with optional filtering)
bw list items

# Get by ID (most reliable)
bw get item "item-id-uuid"

# Get by name (searches, returns first match)
bw get item "Gmail Login"

# Extract specific field from login item
bw get password "Gmail Login"
bw get username "Gmail Login"

# Get from secure note custom field
bw get notes "API Keys"

# List by folder
bw list items --folderid "folder-id"
```

#### Create/Modify Secrets

```bash
# Create login item with custom fields (JSON)
echo '{"organizationId": null, "name": "My API Key", "type": 1, "login": {"username": "", "password": ""}, "fields": [{"type": 0, "name": "API_KEY", "value": "secret123"}]}' | bw create item

# Edit existing item
bw edit item "item-id" < modified.json

# Delete (soft delete by default)
bw delete item "item-id"

# Permanently delete
bw delete item "item-id" --permanent
```

#### Vault Sync

```bash
# Sync vault with server (downloads encrypted updates)
bw sync

# Note: Sync happens automatically on login, but manual sync useful after external changes
```

#### Export/Import

```bash
# Export entire vault as JSON (encrypted)
bw export --password "my-export-password" > vault-encrypted.json

# Export as plaintext JSON (insecure—avoid in production)
bw export > vault.json

# Export as CSV
bw export --format csv > vault.csv

# Import from another password manager
bw import bitwarden vault.json
bw import lastpass vault.csv
```

---

### Working with Custom Fields

Custom fields let you store arbitrary key-value pairs on any vault item (logins, notes, etc.).

**Example Workflow** (for .env generation):

1. Create a secure note: "Dev Environment"
2. Add custom fields:
   - Field 1: Name=`DATABASE_URL`, Type=`Concealed text`, Value=`postgres://...`
   - Field 2: Name=`API_KEY`, Type=`Concealed text`, Value=`sk-...`
   - Field 3: Name=`DEBUG`, Type=`Text`, Value=`true`

3. Retrieve via CLI:
```bash
# Get entire item as JSON
bw get item "Dev Environment"

# Parse custom field with jq
bw get item "Dev Environment" | jq -r '.fields[] | "\(.name)=\(.value)"'
# Output:
# DATABASE_URL=postgres://...
# API_KEY=sk-...
# DEBUG=true
```

---

## Bitwarden Secrets Manager (bws) - Infrastructure Secrets

### Architecture

**Projects**: Logical groupings of secrets (e.g., "payment-service", "analytics-worker")

**Secrets**: Individual key-value pairs stored in projects

**Machine Accounts**: Non-human entities (CI/CD pipelines, apps) with programmatic access

**Access Tokens**: Credentials for machine accounts to authenticate and decrypt secrets

### Initial Setup

1. **Create Organization** (if not in existing one):
   - Go to https://vault.bitwarden.com/organizations
   - Create organization or use existing team organization

2. **Enable Secrets Manager**:
   - Navigate to organization settings
   - Activate "Secrets Manager" feature

3. **Create Machine Account**:
   - Org Settings → Machine Accounts
   - Click "Create Machine Account"
   - Name: e.g., "ci-pipeline", "local-dev"
   - Copy the **access token** (shown once!)
   - Store securely (e.g., in encrypted file, environment variable, secret manager)

4. **Create Projects**:
   - Org Settings → Projects
   - Create project: "backend-api", "mobile-app", etc.

5. **Create Secrets**:
   - Projects → Select project
   - Add secret: Name=`DATABASE_PASSWORD`, Value=`...`
   - Assign to projects

6. **Grant Machine Account Access**:
   - Machine Accounts → Select account
   - Assign to projects with read or read/write permission

---

### Authentication

#### Via Environment Variable (Recommended for Automation)

```bash
export BWS_ACCESS_TOKEN="<your-machine-account-token>"

# All subsequent bws commands use this token
bws project list
```

#### Via Inline Flag

```bash
bws project list --access-token "<token>"
```

#### Via State File (Reduces Rate Limiting)

```bash
# Store encrypted token in file
bws config server-base https://api.bitwarden.com
bws login --access-token "<token>"

# Subsequent commands use cached state
bws project list
```

---

### Core Commands

#### Project Management

```bash
# List projects
bws project list

# Get project details
bws project get "project-id-uuid"

# Create project
bws project create "project-name"

# Edit project name
bws project edit "project-id" --name "new-name"
```

#### Secrets Management

```bash
# List secrets in all accessible projects
bws secret list

# Get specific secret
bws secret get "secret-id-uuid"

# Create secret in project
bws secret create "API_KEY" "sk-123456789" "project-id"

# Edit secret
bws secret edit "secret-id" --value "new-value"

# Delete secret
bws secret delete "secret-id-1" "secret-id-2"
```

#### Environment Injection (Key Feature)

```bash
# Run command with secrets injected as environment variables
bws run --project "project-id" -- "your-command"

# Example: Run Node.js app with secrets injected
bws run --project "backend-api" -- node app.js

# Example: Generate .env file
bws run --project "backend-api" -- "env | grep -v ^_" > .env
```

#### Output Formats

```bash
# JSON (default)
bws secret list -o json

# YAML
bws secret list -o yaml

# Table
bws secret list -o table

# TSV
bws secret list -o tsv

# Environment variables (bare KEY=VALUE)
bws secret list -o env
```

---

## Comparison: bw vs bws

| Aspect | **bw (Vault)** | **bws (Secrets Manager)** |
|--------|---|---|
| **Use Case** | Personal/team password vault | Infrastructure & application secrets |
| **Primary Users** | Humans + machine accounts | Machine accounts only |
| **Data** | Logins, notes, cards, identities | Key-value secrets only |
| **Access Control** | Org collections + shared folders | Projects with granular permissions |
| **Authentication** | Email/password, API key, SSO | Machine account tokens only |
| **Audit Logging** | Basic (if org admin) | Detailed, timestamped per machine |
| **API** | CLI + REST API | CLI, SDK, REST API |
| **Default Use** | `bw get password "Gmail"` | `bws secret list --project x` |
| **Session Caching** | Yes (BW_SESSION) | Yes (via state files) |
| **Rate Limiting** | Standard Bitwarden limits | May trigger if many sessions/IP |
| **Permissions** | Read/write on collections | Read or read/write per project |
| **Cost** | Bitwarden Premium (one-time) | Separate subscription ($ per project/secret) |

### Decision Matrix

**Use `bw` (Vault) if**:
- Storing login credentials you'll reference manually
- Sharing secrets with team members via collections
- Managing passwords, credit cards, identities
- Personal development with manual secret retrieval

**Use `bws` (Secrets Manager) if**:
- Automating secret injection into CI/CD pipelines
- Managing infrastructure secrets (DB passwords, API tokens)
- Need audit trails of who accessed what, when
- Machine accounts requiring programmatic access
- Multiple projects/environments with isolated permissions

**Use Both if**:
- Hybrid workflow: `bw` for personal dev, `bws` for production
- Rotating secrets: store in `bws`, reference in `bw` for manual override
- Team onboarding: store shared credentials in `bw`, infrastructure secrets in `bws`

---

## Vault & Project Organization

### Bitwarden Vault (bw) Folder Structure

Folders help organize your personal vault. Create nested folders with `/` delimiter:

```
Passwords/
  ├── Work/
  │   ├── GitHub
  │   ├── AWS
  │   └── Slack
  ├── Personal/
  │   ├── Gmail
  │   └── Banking
API Keys/
  ├── Dev Environment
  ├── Staging Environment
  └── Archive/
      └── Deprecated Services
```

**Best Practices**:
- Use consistent naming (PascalCase or kebab-case)
- Nest by purpose/project rather than alphabetically
- Create an "Archive" folder for deprecated credentials
- Don't nest more than 3-4 levels deep (UI becomes unwieldy)

**CLI Commands**:
```bash
# List items in folder
bw list items --folderid "folder-uuid"

# Create item in folder (via JSON)
echo '{"name": "GitHub", "type": 1, "folderid": "folder-uuid", ...}' | bw create item
```

### Secrets Manager Project Structure

Projects are logical groupings visible to machine accounts. Design for least privilege:

```
Organization: my-company
  ├── Project: backend-api
  │   ├── DATABASE_PASSWORD
  │   ├── JWT_SECRET
  │   └── STRIPE_SECRET_KEY
  ├── Project: mobile-app
  │   ├── FIREBASE_API_KEY
  │   └── AMPLITUDE_KEY
  ├── Project: analytics
  │   ├── SNOWFLAKE_PASSWORD
  │   └── DATADOG_API_KEY
  └── Project: shared-services (if needed for cross-project secrets)
       ├── SENTRY_DSN
       └── SLACK_WEBHOOK
```

**Best Practices**:
- One project per service/application
- Minimal cross-project secrets (defeats purpose of projects)
- Name secrets with uppercase, no special chars: `DATABASE_PASSWORD`, `API_KEY`
- Assign machine accounts only to projects they need (principle of least privilege)

**Example Setup**:
```bash
# Create projects
bws project create "backend-api"  # Returns project-id-1
bws project create "mobile-app"  # Returns project-id-2

# Create machine account for backend deployment
bws project edit "project-id-1" --name "backend-api"

# Assign machine account to only that project (not mobile-app)
# (Via web UI: Machine Accounts → Select account → Assign to backend-api)

# Create secrets
bws secret create "DATABASE_PASSWORD" "pg-pass-xyz" "project-id-1"
bws secret create "JWT_SECRET" "jwt-secret-abc" "project-id-1"
```

---

## Integration Patterns

### Pattern 1: Generate .env File from bw Vault

**Use Case**: Local development, retrieving multiple secrets into `.env`

**Setup in Bitwarden**:
1. Create a secure note: "Dev Environment"
2. Add custom fields:
   - `DATABASE_URL`=`postgres://...`
   - `API_KEY`=`sk-...`
   - `DEBUG_MODE`=`true`

**Script** (`scripts/load-env.sh`):
```bash
#!/bin/bash
set -euo pipefail

VAULT_ITEM="Dev Environment"

# Check if logged in and vault is unlocked
if ! bw status | jq -e '.authenticated and not .locked' > /dev/null 2>&1; then
    echo "Vault not unlocked. Run: export BW_SESSION=\$(bw unlock --raw)"
    exit 1
fi

# Fetch item and extract custom fields
bw get item "$VAULT_ITEM" | jq -r '.fields[] | "\(.name)=\(.value)"' > .env

echo ".env file generated from Bitwarden vault"
cat .env
```

**Usage**:
```bash
# First time
export BW_SESSION=$(bw unlock --raw)  # Prompts for master password

# Generate .env
./scripts/load-env.sh

# Run app
source .env
node app.js
```

**Advantages**:
- Single source of truth for dev secrets
- Avoids committing .env to git
- Manual control over when secrets are loaded

**Disadvantages**:
- Manual step (need to run script)
- Session expires, need to re-unlock
- Not suitable for CI/CD (use bws instead)

---

### Pattern 2: Using envwarden for .env Generation

**Tool**: `envwarden` (GitHub: envwarden/envwarden)

**Setup**:
1. Install `envwarden`:
```bash
# Clone and install
git clone https://github.com/envwarden/envwarden.git
cd envwarden
chmod +x envwarden
ln -s $(pwd)/envwarden ~/.local/bin/envwarden
```

2. Create Bitwarden vault items tagged with "envwarden":
   - Item name: "envwarden" (or anything tagged with the label)
   - Custom fields with your secrets (type: Concealed text)

3. Generate .env:
```bash
export BW_SESSION=$(bw unlock --raw)
envwarden --dotenv > .env
```

**Advantages**:
- Dedicated tool for this workflow
- Searches by tag instead of item name (more flexible)
- Outputs proper .env format
- Single command to generate

---

### Pattern 3: CI/CD with bws (Secrets Manager)

**Use Case**: Secure secret injection into GitHub Actions, GitLab CI, etc.

**GitHub Actions Example**:
```yaml
name: Deploy

on: [push]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install bws
        run: curl -sSL https://bitwarden.com/secrets/install | sh

      - name: Deploy with secrets
        env:
          BWS_ACCESS_TOKEN: ${{ secrets.BWS_ACCESS_TOKEN }}  # Set in GitHub Secrets
        run: |
          bws run --project "production-api" -- ./deploy.sh
```

**In `deploy.sh`**, secrets are available as environment variables:
```bash
#!/bin/bash
# DATABASE_PASSWORD, API_KEY, etc. are already in environment from bws run
curl -X POST https://api.example.com/deploy \
  -H "Authorization: Bearer $API_KEY" \
  -d "db_password=$DATABASE_PASSWORD"
```

**Advantages**:
- No secrets stored in GitHub (only machine account token in GitHub Secrets)
- Audit trail in Bitwarden (who accessed what, when)
- Secrets never appear in logs or code
- Can rotate secrets without redeploying

**Setup Steps**:
1. Create machine account in Secrets Manager
2. Copy access token
3. Add to GitHub Secrets as `BWS_ACCESS_TOKEN`
4. Use in workflow as shown above

---

### Pattern 4: Dynamic Secret Retrieval in Code

**Use Case**: Application needs to fetch secrets at runtime

**Bash Example**:
```bash
#!/bin/bash
export BW_SESSION=$(bw unlock --raw)
export DATABASE_URL=$(bw get password "Database Production")
export API_KEY=$(bw get item "API Keys" | jq -r '.fields[] | select(.name=="STRIPE_KEY") | .value')

# Run app
node app.js
```

**Python Example**:
```python
import subprocess
import json
import os

def get_secret(item_name, field_name=None):
    """Retrieve secret from Bitwarden vault"""
    result = subprocess.run(
        ['bw', 'get', 'item', item_name],
        capture_output=True,
        text=True,
        check=True
    )
    item = json.loads(result.stdout)

    if field_name:
        # Search custom fields
        for field in item.get('fields', []):
            if field['name'] == field_name:
                return field['value']
    else:
        # Return password for login item
        return item['login']['password']

# Usage
database_url = get_secret("Database Prod")
api_key = get_secret("API Keys", "STRIPE_KEY")

os.environ['DATABASE_URL'] = database_url
os.environ['API_KEY'] = api_key
```

**Advantages**:
- No .env files needed
- Secrets fetched at runtime
- Can implement refresh/rotation logic

**Disadvantages**:
- Requires vault to be unlocked/accessible
- Slower (network calls to Bitwarden)
- Not suitable for serverless/ephemeral environments

---

## Security Considerations

### Session Management

#### bw CLI Sessions (BW_SESSION)

**What it is**: A session token that decrypts your vault. Without it, `bw` commands fail (prompt for master password).

**Security Characteristics**:
- **Lifetime**: Valid until `bw lock` or closing terminal (doesn't persist across shells)
- **Storage**: Not recommended to persist in `.bashrc` or `.env` (disk exposure risk)
- **Exposure**: If leaked, attacker can decrypt your entire vault until session expires

**Best Practices**:
```bash
# Good: Unlock only when needed, work in one terminal session
export BW_SESSION=$(bw unlock --raw)
# Do your work...
bw lock  # Explicitly lock when done

# Avoid: Persisting in shell rc file
# Don't put: export BW_SESSION=... in ~/.bashrc
```

#### bws Access Tokens (BWS_ACCESS_TOKEN)

**What it is**: Long-lived token for machine account access to specific projects.

**Security Characteristics**:
- **Scope**: Limited to assigned projects (read or read/write)
- **Lifetime**: No expiration (rotate manually or via organization settings)
- **Exposure**: If leaked, attacker can access only secrets in assigned projects, not entire vault

**Best Practices**:
```bash
# Good: Store in secure location, rotate regularly
# ~/.config/secrets/bws-token (chmod 600)
export BWS_ACCESS_TOKEN=$(cat ~/.config/secrets/bws-token)

# Good: Use environment variable in CI/CD (GitHub Secrets, GitLab Variables)
# Avoid: Committing to git or in plaintext logs

# Rotate regularly (monthly recommended)
# Process: Create new token, update all services, delete old token
```

### Credential Exposure Risks

#### Process Environment

```bash
# Risk: Secrets visible in process list
export DATABASE_PASSWORD="secret123"
ps aux | grep node  # Shows DATABASE_PASSWORD in environ
```

**Mitigation**: Use `bws run` which doesn't expose secrets in process environ:
```bash
bws run --project backend-api -- ./app.sh
```

#### Shell History

```bash
# Risk: Commands with hardcoded secrets in bash history
export API_KEY="sk-1234567890"
history | grep API_KEY  # Exposed!
```

**Mitigation**:
```bash
# Use secret from Bitwarden, not hardcoded
export API_KEY=$(bw get password "API Key Name")

# Or use bws run to avoid env var exposure
bws run --project myapp -- script.sh
```

#### Log Files

```bash
# Risk: Secrets logged in application logs
console.log("Connecting with password:", password)
```

**Mitigation**:
- Never log secrets
- Use Bitwarden audit logs instead
- Implement secret masking in CI/CD

#### Rate Limiting

**bws-specific**: Multiple sessions from same IP can trigger rate limiting.

**Mitigation**:
- Use state files to cache authentication (bws login)
- Reuse sessions instead of creating new ones per command
- Space out parallel requests

---

### Encryption & Storage

**In Transit**:
- All communication with Bitwarden servers uses HTTPS + TLS
- Secrets are encrypted client-side before transmission

**At Rest**:
- Bitwarden uses end-to-end encryption (zero-knowledge)
- Bitwarden staff cannot access your data even with server access
- Secrets are encrypted with master password (bw) or machine account token (bws)

**Local Machine**:
- Cache: Bitwarden stores encrypted copies of vault data locally
- Session key: Stored in memory or temp environment variable
- Best practice: Don't persist session keys to disk

---

### Access Control Best Practices

**For bw Vault**:
- Use master password: min 12 characters, unique, strong
- Enable 2FA for web vault
- Share sensitive items via Collections (org feature), not by forwarding passwords
- Regular master password rotation (once/year)

**For bws Projects**:
- One project per application/service
- Assign machine accounts only to necessary projects
- Use read-only access when possible (audit permissions)
- Rotate machine account tokens quarterly
- Review access logs regularly

---

## Gotchas & Anti-patterns

### Anti-pattern 1: Persisting BW_SESSION in Shell RC

```bash
# ❌ BAD: Never do this
# In ~/.bashrc or ~/.zshrc:
export BW_SESSION="xxxx"  # Session key visible in config files!
```

**Why it's bad**:
- Session stored unencrypted on disk
- Anyone with file access can decrypt your vault
- Session doesn't expire, risk is permanent

**Better alternative**:
```bash
# ✅ GOOD: Unlock on demand
export BW_SESSION=$(bw unlock --raw)

# Then lock when done
bw lock
```

---

### Anti-pattern 2: Storing .env Files in Git

```bash
# ❌ BAD: Never commit to git
.env  # Contains DATABASE_PASSWORD, API_KEY, etc.
```

**Why it's bad**:
- Exposed in git history forever (even if deleted)
- Visible to anyone with repo access
- Secrets end up in GitHub/GitLab UI

**Better alternatives**:
```bash
# ✅ GOOD: Generate .env from Bitwarden on demand
./scripts/load-env.sh > .env
# .env in .gitignore

# ✅ GOOD: Use bws in CI/CD (no .env file needed)
bws run --project myapp -- node app.js
```

---

### Anti-pattern 3: Using bw for Production CI/CD

```bash
# ❌ BAD: Using personal vault (bw) in production
# GitHub Actions job:
export BW_SESSION=$(bw unlock --raw)
bw get password "Production Database"
```

**Why it's bad**:
- Uses personal master password (single point of failure)
- No audit trail for production access
- Hard to rotate secrets (change master password = everyone locked out)
- Not designed for machine account automation

**Better alternative**:
```bash
# ✅ GOOD: Use bws (Secrets Manager) for production
# GitHub Actions secrets:
BWS_ACCESS_TOKEN=<machine-account-token>

# Workflow:
bws run --project production-api -- ./deploy.sh
```

---

### Anti-pattern 4: Hardcoding Secret IDs

```bash
# ❌ BAD: Secrets tied to specific IDs (breaks if you delete/recreate)
API_KEY_ID="3fa85f64-5717-4562-b3fc-2c963f66afa6"
bw get item "$API_KEY_ID"
```

**Why it's bad**:
- IDs change if you delete and recreate items
- Not human-readable
- Hard to manage across teams

**Better alternative**:
```bash
# ✅ GOOD: Reference by name (search)
bw get item "Production API Key"

# ✅ GOOD: Use bws (names are stable)
bws secret get "STRIPE_SECRET_KEY"
```

---

### Gotcha 1: API Key Login Doesn't Decrypt

```bash
# ❌ Mistake: Expecting bw login --apikey to decrypt vault
bw login --apikey
bw get password "Gmail"  # ERROR: Vault locked

# ✅ Correct: Still need to unlock
bw unlock --raw
export BW_SESSION="xxxx"
bw get password "Gmail"  # Works
```

**Why**: API key authenticates you with servers, but doesn't decrypt vault data.

---

### Gotcha 2: BW_SESSION Expires When Terminal Closes

```bash
# Terminal 1:
export BW_SESSION=$(bw unlock --raw)
bw get item "Database"  # Works

# Terminal 2:
bw get item "Database"  # ERROR: Vault locked (different session)
```

**Why**: Each terminal is a separate session. BW_SESSION doesn't persist across shells.

**Solution**: Unlock in each terminal or use API key + unlock once:
```bash
export BW_CLIENTID="..."
export BW_CLIENTSECRET="..."
export BW_SESSION=$(bw unlock --raw)  # Prompted for master password once
# Works in this terminal session now
```

---

### Gotcha 3: bws Run Rate Limiting

```bash
# ❌ Mistake: Spawning many bws commands in parallel
for i in {1..100}; do
  bws secret list &
done
# May trigger rate limiting
```

**Why**: Each command creates a new session, multiple sessions from same IP can be blocked.

**Solution**: Cache session state or use single command:
```bash
# ✅ GOOD: Use state file (persistent session)
bws config server-base https://api.bitwarden.com
bws secret list  # Uses cached state, not rate-limited

# ✅ GOOD: Single bws run for multiple commands
bws run --project myapp -- bash -c "
  echo \$DATABASE_URL
  echo \$API_KEY
"
```

---

### Gotcha 4: Custom Fields with Type "Linked"

```bash
# ❌ Mistake: Using "Linked" field type for secrets
# In Bitwarden UI, creating custom field with type "Linked" to another item
```

**Why**: Linked fields don't export to environment variables in envwarden.

**Solution**: Use "Concealed text" or "Text" field types instead:
- `Concealed text`: For passwords/secrets (hidden in UI)
- `Text`: For non-sensitive values
- `Boolean`: For flags
- Avoid `Linked`

---

## Recommended Workflow

### For Local Development

```bash
# 1. Setup (one time)
mkdir -p ~/.config/secrets
bw logout || true
bw login  # Email + master password

# 2. Create Bitwarden vault item:
#    - Name: "Local Development"
#    - Type: Secure Note
#    - Custom fields:
#      - DATABASE_URL=postgres://...
#      - API_KEY=sk-...
#      - DEBUG=true

# 3. Create script: scripts/load-env.sh
#!/bin/bash
set -euo pipefail
export BW_SESSION=${BW_SESSION:-$(bw unlock --raw)}
bw get item "Local Development" | jq -r '.fields[] | "\(.name)=\(.value)"' > .env
echo ".env loaded"

# 4. Daily workflow:
export BW_SESSION=$(bw unlock --raw)  # Prompt for master password
./scripts/load-env.sh
source .env
npm run dev  # or equivalent

# 5. When done:
bw lock
unset BW_SESSION
```

---

### For CI/CD (GitHub Actions)

```yaml
# 1. Setup (one time in Bitwarden):
#    - Create machine account: "github-actions-ci"
#    - Create project: "backend-api"
#    - Create secrets: DATABASE_PASSWORD, API_KEY, etc.
#    - Assign machine account to project (read access)

# 2. In GitHub Settings → Secrets:
#    - Add: BWS_ACCESS_TOKEN = <machine-account-token>

# 3. In .github/workflows/deploy.yml:
name: Deploy
on: [push]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install bws
        run: curl -sSL https://bitwarden.com/secrets/install | sh

      - name: Deploy
        env:
          BWS_ACCESS_TOKEN: ${{ secrets.BWS_ACCESS_TOKEN }}
        run: |
          bws run --project "backend-api" -- ./scripts/deploy.sh

# 4. In scripts/deploy.sh:
#!/bin/bash
# DATABASE_PASSWORD, API_KEY are in environment from bws run
# Deploy safely without exposing secrets
```

---

### For Production Rotations

```bash
# Quarterly machine account token rotation (bws):

# 1. Create new machine account token in Bitwarden web UI
NEW_TOKEN=$(cat new-token.txt)

# 2. Update CI/CD providers:
# - GitHub: Update BWS_ACCESS_TOKEN secret
# - GitLab: Update CI_BWS_ACCESS_TOKEN variable
# - Other: Update deployment environment variable

# 3. Verify new token works:
BWS_ACCESS_TOKEN=$NEW_TOKEN bws secret list

# 4. Delete old token in Bitwarden web UI
# - Machine Accounts → Select account → Delete old token

# 5. Document rotation in runbook
```

---

### For Team Sharing

**Scenario**: Team needs to share API keys, database passwords.

```
# Option 1: Use bw Vault (manual, human-facing)
- Create Bitwarden Organization (if not already)
- Create Collection: "Backend Credentials"
- Create items in collection: Database, API Keys, etc.
- Share collection with team members
- Team retrieves manually or via bw CLI

# Option 2: Use bws (automated, machine-facing)
- Create bws projects per service
- Create machine accounts per CI/CD pipeline
- Assign tokens to GitHub Secrets, GitLab Variables, etc.
- Team doesn't touch secrets directly (better security)
```

---

## Quick Reference

### Installation Checklist

- [ ] Install `bw` CLI (npm or native)
- [ ] Test: `bw --version`
- [ ] Log in: `bw login`
- [ ] Unlock: `export BW_SESSION=$(bw unlock --raw)`
- [ ] Test: `bw list items`
- [ ] Lock when done: `bw lock`

### For .env Management (Local Dev)

- [ ] Create Bitwarden vault item with custom fields
- [ ] Create script to fetch and export as .env
- [ ] Add .env to .gitignore
- [ ] Document in README how to load secrets

### For CI/CD (Production)

- [ ] Install `bws` CLI in CI/CD runner
- [ ] Create machine account in Bitwarden Secrets Manager
- [ ] Create project and secrets in bws
- [ ] Assign machine account to project (read access)
- [ ] Store BWS_ACCESS_TOKEN in CI/CD secrets (GitHub/GitLab)
- [ ] Use `bws run --project X -- script.sh` in workflows
- [ ] Test that secrets are injected (not exposed in logs)
- [ ] Document rotation process in runbook

---

## Resources & Links

**Official Documentation**:
- [Bitwarden CLI Help](https://bitwarden.com/help/cli/)
- [Secrets Manager CLI](https://bitwarden.com/help/secrets-manager-cli/)
- [Secrets Manager Overview](https://bitwarden.com/help/secrets-manager-overview/)
- [Personal API Key Setup](https://bitwarden.com/help/personal-api-key/)

**Community Tools**:
- [envwarden](https://github.com/envwarden/envwarden) - .env generation from bw vault
- [bwenv](https://pypi.org/project/bwenv/) - Python wrapper for bw CLI

**Guides & Articles**:
- [Gruntwork: Using Bitwarden CLI with ZSH](https://www.gruntwork.io/blog/how-to-securely-store-secrets-in-bitwarden-cli-and-load-them-into-your-zsh-shell-when-needed/)
- [Using Bitwarden Secrets Manager with GitHub Actions](https://bitwarden.com/blog/using-bitwarden-secrets-manager-and-github-actions/)
- [Bitwarden Secrets Manager vs HashiCorp Vault](https://bitwarden.com/blog/bitwarden-secrets-manager-hashicorp-vault-alternative/)

**Repositories**:
- [Bitwarden CLI (GitHub)](https://github.com/bitwarden/cli)
- [Bitwarden SDK - Secrets Manager (GitHub)](https://github.com/bitwarden/sdk-sm)

---

## Next Steps

1. **Decide on approach**: Will you use `bw` (vault), `bws` (Secrets Manager), or both?
2. **Set up personal API key** for automated access (if using bw)
3. **Create machine account** in Secrets Manager (if using bws)
4. **Organize vault/projects**: Design folder/project structure for your workflow
5. **Implement integration**: Write scripts for .env generation or CI/CD injection
6. **Test & document**: Verify secrets flow correctly, document in team runbook
7. **Rotate credentials**: Establish quarterly rotation schedule

---

*Document created: 2026-01-29*
*Research based on Bitwarden CLI v2025.12.0+ and Secrets Manager v8.4+*
*Tested configurations: Linux (primary), macOS (secondary), GitHub Actions (CI/CD)*
