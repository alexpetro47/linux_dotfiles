# Setup

1. download install script

``` curl -o ~/.config/make_installs.sh https://raw.githubusercontent.com/justatoaster47/linux_dotfiles/refs/heads/main/make_installs.sh ```

2. make install script executable

``` chmod +x ~/.config/make_installs.sh ```

NOTE: It may fail for portions, so it could be advised to comment out everything past the
loop downloads (which don't generally fail) and run clumps of commands in a split window,
fixing issues as they arise

3. run install script

``` ~/.config/make_installs.sh ```

