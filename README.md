# New Machine Setup

Automated dotfiles bootstrap for fresh Ubuntu. Idempotent - safe to re-run.

## Quick Start

```bash
# Full install
curl -fsSL https://raw.githubusercontent.com/justatoaster47/linux_dotfiles/main/new-machine-setup/bootstrap.sh | bash

```

- `git-credential-manager configure`
- brave
  - sync account
  - login to bitwarden + browser extension
- spotify login

## Re-run Individual Phases

```bash
cd ~/.config/new-machine-setup
./install-packages.sh
./verify.sh
```

Logs: `~/bootstrap-<timestamp>.log`

