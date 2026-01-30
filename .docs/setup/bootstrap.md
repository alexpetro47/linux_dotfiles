# Bootstrap

Entry point for fresh machine setup. Orchestrates all installation phases in sequence.

## Location

`new-machine-setup/bootstrap.sh`

## Usage

```bash
# Remote execution (fresh machine)
curl -fsSL https://raw.githubusercontent.com/justatoaster47/linux_dotfiles/main/new-machine-setup/bootstrap.sh | bash

# Local execution
./new-machine-setup/bootstrap.sh
```

## Sequence

1. Clone repository to `~/.config` (if not already present)
2. Run `install-packages.sh`
3. Run `link-configs.sh`
4. Run `configure-system.sh`
5. Run `verify.sh`
6. Print post-install instructions

## Behavior

- Clones from GitHub if `~/.config` doesn't exist or isn't a git repo
- Each phase runs independently; failures in one don't block others
- Outputs colored status for each phase
- Safe to re-run (all phases are idempotent)

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All phases completed (may have warnings) |
| 1 | Clone failed |

## Notes

- Requires internet connection for initial clone and package downloads
- Some packages require reboot to take effect (noted by verify.sh)
- Manual post-install steps listed at completion
