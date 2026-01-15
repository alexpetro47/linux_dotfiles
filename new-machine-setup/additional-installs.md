
# ADDITIONAL INSTALLS

## Desktop

picom - compositor for transparency/shadows (disabled - causes idle crashes)
`sudo apt install picom`

## Fonts

FiraCode Nerd Font - alternative monospace font (ligatures)
```
mkdir -p ~/.local/share/fonts
curl -fLo /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip -o /tmp/FiraCode.zip -d ~/.local/share/fonts/FiraCode
fc-cache -fv
rm /tmp/FiraCode.zip
```

## Development

c qa libs
```
sudo apt install clang-format clang-tidy cppcheck
```

demongrep
```
sudo apt-get update
sudo apt-get install -y build-essential protobuf-compiler libssl-dev pkg-config
cd /tmp/
git clone https://github.com/yxanul/demongrep.git
cd demongrep
cargo build --release
sudo cp target/release/demongrep ~/.local/bin 
```

rclone gdrive remote - for backup-repos script
```
rclone config
# n (new remote) → gdrive → drive → leave client_id/secret blank
# → 1 (full access) → n (no advanced) → n (no auto config on headless)
# → paste auth URL in browser, copy code back → n (not team drive) → y (confirm)
```

simplenote-local - sync simplenote to local markdown files
```
git clone git@github.com:alexpetro/notes3.git ~/Documents/notes3
cd ~/Documents/notes3/sn
cp .env.example .env
# edit .env with credentials
uv sync
./run init
mkdir -p ~/.config/systemd/user
cp simplenote-sync.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now simplenote-sync
```

lazysql - tui for databases
`go install github.com/jorgerojas26/lazysql@latest`

usql - universal sql cli
`go install github.com/xo/usql@latest`

marp - markdown presentation cli
`npm i -g @marp-team/marp-cli`

cloudflared - cloudflare tunnel client
```
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared jammy main' | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt update && sudo apt install -y cloudflared
```

ngrok - localhost tunneling
```
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update && sudo apt install -y ngrok
```

azure-cli - azure command line
`curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash`

d2 - declarative diagramming
`curl -fsSL https://d2lang.com/install.sh | sh`

drawio - diagram editor
`curl -fLo ~/.local/bin/drawio "https://github.com/jgraph/drawio-desktop/releases/download/v28.0.6/drawio-x86_64-28.0.6.AppImage" && chmod +x ~/.local/bin/drawio`

blender - 3d modeling
```
curl -L https://download.blender.org/release/Blender4.2/blender-4.2.1-linux-x64.tar.xz | tar -xJ -C ~/.local
ln -sf ~/.local/blender-4.2.1-linux-x64/blender ~/.local/bin/blender
```

~sqlite-vec - vector extension for sqlite~
```
mkdir -p ~/.local/lib
curl -L https://github.com/asg017/sqlite-vec/releases/download/v0.1.3/sqlite-vec-0.1.3-loadable-linux-x86_64.tar.gz | tar -xz -C ~/.local/lib
```

neo4j - graph database (docker)
`docker run -p 7474:7474 -p 7687:7687 -e NEO4J_AUTH=neo4j/password neo4j`

reaper - digital audio workstation (manual)
https://www.reaper.fm/download.php

dbgate - database gui (manual)
https://dbgate.org/download/

amdgpu PSR fix - ThinkPad P14s Gen 6 / Ryzen AI 9 HX 370 / Radeon 890M
```
# Fixes input freezes, screen not updating (PSR regression in kernel 6.11+)
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 amdgpu.dcdebugmask=0x10"/' /etc/default/grub
sudo update-grub && sudo reboot
```

alacritty - terminal emulator (alternative to kitty, no image support)
`sudo apt install alacritty`

## ML/Data Science

Miniforge3 - conda distribution using conda-forge (avoids Anaconda licensing)
```
wget -qO /tmp/miniforge.sh https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash /tmp/miniforge.sh -b -p ~/.local/miniforge3
~/.local/miniforge3/bin/conda init zsh
# Restart shell, then:
conda config --set auto_activate_base false
conda config --set channel_priority strict
```

## ML/Media Processing (for ~/.claude/skills media toolkits)

PyTorch + CUDA (required for GPU acceleration)
```
# Check CUDA version first: nvidia-smi
# Then install matching PyTorch: https://pytorch.org/get-started/locally/
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```

HuggingFace Transformers - Florence-2, SigLIP
`pip install transformers accelerate`

faster-whisper - audio transcription
`pip install faster-whisper`

pyannote-audio - speaker diarization (requires HF token)
```
pip install pyannote-audio
# Get token from: https://huggingface.co/pyannote/speaker-diarization
# Then: export HF_TOKEN="your_token"
```

ultralytics - YOLO object detection
`pip install ultralytics`

ffmpeg - required for audio/video processing
`sudo apt install ffmpeg`

ImageMagick - image processing
`sudo apt install imagemagick`

openjdk - java compiler and runtime (headless)
`sudo apt install openjdk-21-jdk-headless`
