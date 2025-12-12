
# INIT GUIDE


## PC
* [PC] MINISFORUM UM890 Pro Barebone with Mini PC, AMD Ryzen 9 8945HS Mini Computers,8K Quad Display HDMI/DP1.4/USB4 х 2, AMD Radeon 780M/Dual LAN 2.5G 
* [RAM/MEM] Crucial 96GB DDR5 RAM, 5600MHz (or 5200MHz or 4800MHz) Laptop Memory Kit, SODIMM 262-Pin, Compatible with 13th Gen Intel Core and AMD Ryzen 6000 - CT2K48G56C46S5
* [SSD] Crucial P3 Plus 4TB PCIe Gen4 3D NAND NVMe M.2 SSD, up to 5000MB/s - CT4000P3PSSD8
https://www.youtube.com/watch?v=wyF0I64j_1M
1. remove top
2. unscrew second layer
3. insert ram at 45 degrees, push down upper end until clicks in
4. unscrew the screw on rhs for ssd
5. insert ssd at 45 degrees, push down gently, secure by rescrewing
6. power on, wait 2-3 min
7. power off
8. connect hdmi cable to monitor
9. power on - shoudl show boot menu on screen


## BOOTING OS (LINUX MINT)
https://www.youtube.com/watch?v=vFn6EHAilNs
1. download linux mint iso [https://linuxmint.com]
   * from berkeley since its close
2. insert usb into device
3. `sudo fdisk -l` then find the usb name (e.g. `/dev/sdb`)
4. `sudo dd if=/path/to/your.iso of=path/to/usb bs=4M status=progress && sync`
   e.g. `sudo dd if=/home/alexpetro/Downloads/linuxmint-22.1-xfce-64bit.iso of=/dev/sdb bs=4M status=progress && sync`
     (takes a minute or two, no visible progress sometimes)
5. check its downloaded e.g. `sudo file -s /dev/sdb`
6. eject from laptop
    * `sudo umount /dev/sdb`
    * `sudo eject /dev/sdb`
    * `sudo file -s /dev/sdb` should be empty
7. insert into PC
8. boot (with mine its just a boot gui button) - other devices may have some
   F7 F11 etc keypress combos
   (on thinkpad its F12 to boot from temporary device -> usb)
9. select linux mint in boot option
   [at this point, you can wipe old os's as well, see below]
10. double click install on linux mint preview to download to SSD
11. at some point you'll have wifi menu - plug in LAN ethernet, back to last
menu, then it should skip this with a ethernet connected message on
screen

[yes] multimedia codes

### wiping usb
1. insert usb
2. `lsblk -f` (nvme0n1 is your current os (careful), sda is usb)
3. `sudo wipefs -a /dev/sda` wipe all signatures from usb
4. `sudo sgdisk --zap-all /dev/sda` wipe all partitions from usb
5. `lsblk -f` should now show clean sda

### wiping old os
CAREFUl this wipes your fucking harddrive
lsblk
~~ sudo wipefs -a /dev/nvme0n1 ~~
~~ sudo sgdisk --zap-all /dev/nvme0n1 ~~
lsblk

---

sudo apt update && sudo apt upgrade

## INSTALL CHROME
google.com/chrome
download the .deb or whatever, install via gui. 
*login to google*

## DOTFILES
cd ~ 
git clone https://github.com/justatoaster47/linux_dotfiles
cd linux_dotfiles
cp -r * ~/.config

## NVIM
cd ~ 
sudo apt install cmake
git clone --branch stable --depth 1 https://github.com/neovim/neovim.git 
cd neovim 
make CMAKE_BUILD_TYPE=RelWithDebInfo 
sudo make install 
nvim --version && which nvim
use lazy-lock restore if broken packages

## ZSH
sudo apt install zsh zsh-autosuggestions zsh-syntax-highlighting
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
rm ~/.zshrc
ln -s ~/.config/zsh/.zshrc ~/.zshrc
source ~/.zshrc
chsh -s $(which zsh)

[use starship (rust+cargo) instead of p10k]

## TMUX/ALACRITTY
sudo apt install tmux alacritty
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/scripts/install_plugins.sh
pkill tmux && rm -rf /tmp/tmux-*

## I3 + Gaps
sudo apt install i3 polybar rofi feh picom
check for syntax: i3 -C -V -c ~/.config/i3/config
sudo apt install meson libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev
libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev
libev-dev libxcb-xrm-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev
libxkbcommon-x11-dev autoconf xutils-dev libtool automake
libxcb-xinerama0-dev libxcb-xrm-dev
cd ~
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
mkdir -p build && cd build
meson ..
ninja
sudo ninja install
pkill -KILL -u $USER

## NERD FONTS + CURSOR THEME
cd ~/Documents
git clone  https://github.com/justatoaster47/os_styling
cd os_styling
mkdir -p /home/alexpetro/.local/share/fonts
cp -r JetBrainsMonoNF/*.ttf /home/alexpetro/.local/share/fonts
mkdir -p /home/alexpetro/.icons
cp -r ComixCursorWhite/ /home/alexpetro/.icons/

other opts listed in the installation.md as well

## X11 / XCONF SETTINGS
ln -s ~/.config/.xsessionrc ~/.xsessionrc

## SYNC NEW .CONFIG TO GITHUB
cd ~/.config
git init
git checkout -b main
git remote add origin https://github.com/justatoaster47/linux_dotfiles
git branch --set-upstream-to=origin/main
git fetch origin
git rebase
*fix conflicts and push*

## SET UP DOCUMENTS DIR
cd ~/Documents
git clone https://www.github.com/justatoaster47/notes
git clone https://www.github.com/justatoaster47/images
mkdir code
clone any current code projects into Documents/code/
e.g. git clone https://www.github.com/justatoaster47/

## OTHER INSTALLS
see [./other-installs.sh]

### keychron config in browser
https://launcher.keychron.com/#/keymap
https://usevia.app/

generally linux permissions issues.
* check usevia logs
* check `chrome://device-log`

fixes found:
`echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0340", MODE="0666"' | sudo tee /etc/udev/rules.d/92-viia.rules`
`sudo udevadm control --reload-rules && sudo udevadm trigger`





