
# INSTALLS

## BOOT (UBUNTU SERVER)

### creating bootable usb
1. download Ubuntu Server ISO LTS from https://ubuntu.com/download/server
2. insert USB into current machine
3. get usb name (assumes `/dev/sdb`)
   - `sudo fdisk -l`
4. write ISO to USB 
```bash
sudo dd if=<step-1-ubuntu-iso-path> of=<step-3-usb-path> bs=4M status=progress && sync
```
- (may auto eject after step 4)
5. verify 
`sudo file -s /dev/sdb`
  - should return something like
  "/dev/sdb: ISO 9660 CD-ROM filesystem data (DOS/MBR boot sector) 'Ubuntu-Server 24.04.3 LTS amd64' (bootable)"
6. eject `sudo eject /dev/sdb`

### installation
1. insert USB into target machine, turn on, boot from USB 
   - interrupt (spam press "enter" on Lenovo sign coming up)
   - check BIOS (F1 or F2) for disabled secure boot or
   allowed 3rd party booters, boot mode: UEFI 
   - then Boot Menu (F12) select `UEFI: SanDisk` or whatever
   usb type you have, to select the OS to boot from
2. select "Install Ubuntu Server" [on problematic devices,
   can edit boot commands here: e.g. 'e' to edit, then add
'quiet splash nomodeset' on the 'linux' line just before
'---']
3. installation choices:
   - keyboard: English (US)
   - network: configure ethernet/wifi as needed
   - proxy: leave blank
   - mirror: default
   - storage: use entire disk (or manual partitioning)
   - profile: set username/password/hostname
   - SSH: enable OpenSSH server (optional)
   - snaps: skip all (we'll install manually)
4. reboot, remove USB when prompted

### post-install base setup
```bash
sudo apt update && sudo apt upgrade -y
```

### wiping usb (after installation)
```bash
lsblk -f                        # identify USB (sda/sdb, not nvme0n1)
sudo wipefs -a /dev/sdb         # wipe signatures
sudo sgdisk --zap-all /dev/sdb  # wipe partitions
```

### wiping old os (DESTRUCTIVE - careful)
```bash
lsblk
# sudo wipefs -a /dev/nvme0n1
# sudo sgdisk --zap-all /dev/nvme0n1
```

---


## APT
```
sudo apt update && sudo apt install\
  git\
  cmake\
  zsh\
  tmux\
  alacritty\
  i3\
  polybar\
  rofi\
  feh\
  picom\
  mintupgrade\
  fzf\
  nemo\
  ripgrep\
  btop\
  trash-cli\ 
  zathura zathura-pdf-poppler\
  vlc\
  flameshot\
  simplescreenrecorder\
  playerctl\
  cbonsai\
  python3\
  xclip\
  xdotool\
  curl\
  zip\
  unzip\
  wget\
  qjackctl\
  zoxide\
  eza\
  pandoc\
  openshot-qt\
  rclone\
  keepassxc\
  ffmpeg\
  caffeine\
  texlive-latex-recommended texlive-fonts-recommended texlive-xetex\
  texlive-latex-extra texlive-science texlive-pictures\
  texlive-bibtex-extra latexmk texlive-font-utils texlive-plain-generic\
  sqlite-3\
  libsqlite3-dev\

  xorg mesa-utils\
  greetd\
  pipewire pipewire-pulse pipewire-jack wireplumber pavucontrol\
  network-manager\

```

## UV (PIP/PIPX ALTERNATIVE)
```
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install jupyterlab
uv tool install ruff
uv tool install pytest
uv tool install pyright
uv tool install pre-commit
```

## RUST/CARGO/BINSTALL
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.zshrc
rustup update
cargo install cargo-binstall
rustup component add rust-analyzer rust-src
cargo binstall\
  xh\
  starship\
  fd-find\

  tuigreet\
```

## NODE/NPM (or use `bun add -g` for modern stack)
```
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install nodejs
```

## CLAUDE CODE
```
curl -fsSL https://claude.ai/install.sh | bash
claude mcp add context7 -s user -- npx -y @upstash/context7-mcp@latest
claude mcp add sequential-thinking -s user -- npx -y @modelcontextprotocol/server-sequential-thinking
```

## **GOOGLE CHROME**
```
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable
```

## SPOTIFY
```
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install spotify-client
```

## DRAW IO
```
curl -L https://github.com/jgraph/drawio-desktop/releases/download/v24.7.17/drawio-amd64-24.7.17.deb -o /tmp/drawio.deb
sudo apt install /tmp/drawio.deb
which drawio
```
or
```
cd ~/Downloads
wget https://github.com/jgraph/drawio-desktop/releases/download/v28.0.6/drawio-x86_64-28.0.6.AppImage
chmod +x drawio-x86_64-28.0.6.AppImage
mv drawio-x86_64-28.0.6.AppImage ~/.local/bin/drawio
```
- set theme to "sketch"

## FONTS (NERD FONTS)
*download from https://www.nerdfonts.com/font-downloads*
```bash
mkdir -p ~/.local/share/fonts
unzip ~/Downloads/FiraCode.zip -d ~/.local/share/fonts/FiraCode
fc-cache -fv
```
- font family names:
  - `FiraCode Nerd Font Mono` - monospace, use for terminals (alacritty, kitty, etc)
  - `FiraCode Nerd Font` - proportional, use for editors/IDEs
- set as system default (GTK3/4 apps, Chrome, etc) via `gsettings`
- used in alacritty.toml and chrome settings

## GIT 
**GIT TUI - LAZYGIT**
```
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
```

**GIT CREDENTIAL MANAGER**
```
curl -L https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.0/gcm-linux_amd64.2.6.0.deb -o /tmp/gcm.deb
sudo dpkg -i /tmp/gcm.deb
git-credential-manager configure
```
- then attempt clone / actions of any auth-req'd repo

**GIT GLOBAL CONFIGS**
```
git config --global user.name "Alex Petro"
git config --global user.email "alexmpetro@gmail.com"
git config --list | grep user
git config --global push.autoSetupRemote true
git config --global init.defaultBranch main
# git config --global credential.helper store
# git config --global credential.credentialStore secretservice
git config --global credential.helper /usr/bin/git-credential-manager
git config --global credential.credentialStore secretservice
```

## TMUX SESSIONIZER
`curl -o ~/.local/bin/tmux-sessionizer https://raw.githubusercontent.com/ThePrimeagen/tmux-sessionizer/master/tmux-sessionizer && chmod +x ~/.local/bin/tmux-sessionizer`

## DOCKER
```
sudo apt update && sudo apt install docker.io docker-compose
sudo usermod -aG docker $USER
docker --version
sudo systemctl start docker
newgrp docker
```

---

## POST-INSTALL CONFIG

### greetd (tuigreet)
configure `/etc/greetd/config.toml`:
```toml
[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd i3 --time --remember --asterisks"
user = "greeter"
```

### systemctl enables
```bash
sudo systemctl enable greetd
sudo systemctl enable NetworkManager
sudo systemctl enable docker
```

### verify
```bash
glxinfo | grep "OpenGL renderer"   # xorg/mesa
pactl info | grep "Server Name"    # pipewire
nmcli device status                # networkmanager
```

### DEFAULT APPLICATIONS
```bash
xdg-mime default org.pwmt.zathura.desktop application/pdf
```
---

# EXTRAS

### REAPER
1. download x86_64 version from reaper.fm -> Download
2. extract from tar file...
  * `cd Downloads`
  * `tar -xvf reaper*.xz`
  * cd into extracted folder; same name as above without the .tar.xz
  * `./install-reaper.sh`
  * `ln -s ~/opt/REAPER/reaper ~/.local/bin/reaper`
5. in reaper->settings->audio device
  * auto connect jack to hardware
  * auto connect jack to midi 
  * auto suspend pulseaudio
6. quit reaper
---
1. install jack & dependencies
`sudo apt update && sudo apt install jackd2 qjackctl jack-tools qjackctl`
2. plug in scarlett, check its connected
`aplay -l | grep -i scarlett`
3. configure qjackctl
`qjackctl`
setup -> interface -> find scarlett hw:USB -> save
start
4. open reaper, should be good

### DBGATE
*download dbgate appimage from https://dbgate.org/download/*
```
mv ~/Downloads/dbgate-*.AppImage ~/.local/bin/dbgate && chmod +x ~/.local/bin/dbgate
which dbgate && dbgate &
```

### CLOUDFLARED
```
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared jammy main' | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt update
sudo apt install cloudflared
```

### AZURE CLI
```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login
```

### NEO4J
```
curl -fsSL https://debian.neo4j.com/neotechnology.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/neotechnology.gpg
echo "deb [signed-by=/usr/share/keyrings/neotechnology.gpg] https://debian.neo4j.com stable latest" | sudo tee /etc/apt/sources.list.d/neo4j.list
sudo apt update && sudo apt install neo4j
```

### LUA
```
curl https://raw.githubusercontent.com/DhavalKapil/luaver/master/install.sh | sh
source ~/.zshrc
luaver install 5.4.7
```

### BLENDER
```
curl -L https://download.blender.org/release/Blender4.2/blender-4.2.1-linux-x64.tar.xz | tar -xJ -C ~/.local
ln -sf ~/.local/blender-4.2.1-linux-x64/blender ~/.local/bin/blender
which blender
```

### SQLITE VECTOR EXTENSION
`mkdir -p ~/.local/lib && cd ~/.local/lib`
`curl -L https://github.com/asg017/sqlite-vec/releases/download/v0.1.3/sqlite-vec-0.1.3-loadable-linux-x86_64.tar.gz | tar -xz && chmod +x vec0.so`
verify: `sqlite3 :memory: -cmd ".load $HOME/.local/lib/vec0" "SELECT vec_version();"`

### D2
```
curl -fsSL https://d2lang.com/install.sh | sh
which d2
```

### marp (markdown preview w. latex)
```
wget -qO- https://github.com/marp-team/marp-cli/releases/latest/download/marp-cli-v4.2.3-linux.tar.gz \
| sudo tar xz -C /usr/local/bin
```

### NGROK 
[site](https://dashboard.ngrok.com/get-started/setup/linux)
```
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
  | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
  && echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" \
  | sudo tee /etc/apt/sources.list.d/ngrok.list \
  && sudo apt update \
  && sudo apt install ngrok```
then get auth token 
`ngrok config add-authtoken 2xA3Dec....`

### voice typing w. nerd dictation and vosk
`git clone https://github.com/ideasman42/nerd-dictation.git ~/.config/nerd-dictation`
`cd ~/.config/nerd-dictation`
`uv venv`
`uv pip install vosk`
`wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip`
`unzip vosk-model-small-en-us-0.15.zip`
`mv vosk-model-small-en-us-0.15 model`
`sudo apt install xdotool pulseaudio-utils`
create ~/.local/bin/nerd-dictation-toggle:
```
#!/bin/bash
NERD_DIR="$HOME/.config/nerd-dictation"
 
if pgrep -f "nerd-dictation begin" > /dev/null; then
# End dictation
cd "$NERD_DIR" && uv run ./nerd-dictation end
else
# Begin dictation with auto-timeout after 1 second of silence
cd "$NERD_DIR" && uv run ./nerd-dictation begin \
--vosk-model-dir="$NERD_DIR/model" \
--timeout=1 \
--defer-output
fi
```
Make it executable:
`chmod +x ~/.local/bin/nerd-dictation-toggle`
Add to ~/.config/i3/config:
`bindsym $mod+Shift+v exec --no-startup-id ~/.local/bin/nerd-dictation-toggle`

#### DISABLE SLEEP/LOCK (PC)
* linux mint GUI application "Power Manager" [SET]
  * sleep mode inactive for: Never
  * Display power management: off
  * blank after: Never
  * automatically lock the session: never
* systemd logind - /etc/systemd/logind.conf [SET]
  - IdleAction=ignore - action after idle timeout
  - IdleActionSec=30min - idle timeout duration
* systemd sleep configuration - /etc/systemd/sleep.conf [SET]
  - AllowSuspend=no - disable suspend entirely
  - AllowHibernation=no - disable hibernation
  - AllowHybridSleep=no - disable hybrid sleep
  - AllowSuspendThenHibernate=no - disable suspend-then-hibernate
~sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target~

#### FIREWALL
*for redis local setup, using firewall to block any external access*
*redis config at: `/etc/redis/redis.conf`*
* enable firewall: `sudo ufw enable`
* allow only local access to redis port: `sudo ufw allow from 127.0.0.1 to any port 6379`
* check applied: `sudo ufw status numbered`
---
* Enable auto-start: `sudo systemctl enable redis-server`
* Status: `sudo systemctl status redis-server`
* Test connection: `redis-cli ping` (should return PONG)

#### KEYCHRON CONFIG IN BROWSER
https://launcher.keychron.com/#/keymap
https://usevia.app/
- generally linux permissions issues.
   * check usevia logs
   * check `chrome://device-log`
- fixes found:
   `echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0340", MODE="0666"' | sudo tee /etc/udev/rules.d/92-viia.rules`
   `sudo udevadm control --reload-rules && sudo udevadm trigger`

