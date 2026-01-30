# System Configuration

System-level configuration for git, shell, services, power management, and display settings.

## Location

`new-machine-setup/configure-system.sh`

## Git Configuration

```bash
git config --global user.name "Alex Petro"
git config --global user.email "alexpetro47@gmail.com"
git config --global credential.helper manager
git config --global init.defaultBranch main
```

- Uses Git Credential Manager for authentication
- First push to GitHub opens browser for OAuth

## Default Shell

Sets zsh as the default shell:

```bash
chsh -s $(which zsh)
```

Requires logout/login to take effect.

## Systemd Services

| Service | Purpose |
|---------|---------|
| `docker` | Container runtime |
| `NetworkManager` | Network management |
| `tlp` | Power management |

All services enabled and started:

```bash
sudo systemctl enable --now docker tlp NetworkManager
```

## Power Management (TLP)

Configured for laptop use with AMD/Intel CPUs:

| Setting | Value | Purpose |
|---------|-------|---------|
| `CPU_SCALING_GOVERNOR_ON_AC` | performance | Max speed on AC |
| `CPU_SCALING_GOVERNOR_ON_BAT` | powersave | Battery preservation |
| `CPU_ENERGY_PERF_POLICY_ON_AC` | performance | Intel EPP (if available) |
| `CPU_ENERGY_PERF_POLICY_ON_BAT` | balance_power | Intel EPP (if available) |
| `PLATFORM_PROFILE_ON_AC` | performance | AMD pstate-epp |
| `PLATFORM_PROFILE_ON_BAT` | low-power | AMD pstate-epp |
| `START_CHARGE_THRESH_BAT0` | 40 | Start charging below 40% |
| `STOP_CHARGE_THRESH_BAT0` | 80 | Stop charging at 80% |

Configuration file: `/etc/tlp.conf`

## Default Applications

| MIME Type | Application |
|-----------|-------------|
| `application/pdf` | Zathura |
| `image/*` | nsxiv |

Set via `xdg-mime`:

```bash
xdg-mime default zathura.desktop application/pdf
xdg-mime default nsxiv.desktop image/jpeg image/png image/gif
```

## Docker Group

Adds user to docker group for rootless access:

```bash
sudo usermod -aG docker $USER
```

Requires logout/login to take effect.

## DPI Scaling

Configured in `.xsessionrc` for X11 session:

```bash
# HiDPI scaling
export GDK_SCALE=1
export GDK_DPI_SCALE=1.25
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_SCALE_FACTOR=1.25
export XCURSOR_SIZE=60
xrdb -merge <<< "Xft.dpi: 125"

# Disable GNOME Wayland
export GDMSESSION=i3
export XDG_SESSION_TYPE=x11
```

### Toolkit-Specific Settings

| Toolkit | Variable | Value |
|---------|----------|-------|
| GTK 3/4 | `GDK_DPI_SCALE` | 1.25 |
| Qt | `QT_SCALE_FACTOR` | 1.25 |
| Java | `_JAVA_OPTIONS` | `-Dawt.useSystemAAFontSettings=on` |
| Electron | Per-app flags | `--force-device-scale-factor=1.25` |

## Cursor Theme

ComixCursors-White at 60px:

```bash
gsettings set org.gnome.desktop.interface cursor-theme 'ComixCursors-White'
gsettings set org.gnome.desktop.interface cursor-size 60
```

## Font Configuration

JetBrainsMono Nerd Font as default monospace:

```bash
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 14'
```
