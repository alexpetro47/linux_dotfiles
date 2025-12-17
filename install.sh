#!/bin/bash
#
# Dotfiles Bootstrap Script
# Fresh Ubuntu LTS -> clone dotfiles -> ./install.sh -> fully configured system
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$SCRIPT_DIR/manifest.json"
INSTALLED_FILE="$SCRIPT_DIR/.installed.json"

# Theme colors (from manifest)
C_PRIMARY="\033[38;2;118;159;240m"    # #769ff0
C_SECONDARY="\033[38;2;163;174;210m"  # #a3aed2
C_TEXT="\033[38;2;227;229;229m"       # #e3e5e5
C_MUTED="\033[38;2;160;169;203m"      # #a0a9cb
C_SUCCESS="\033[38;2;152;195;121m"    # #98c379
C_WARN="\033[38;2;229;192;123m"       # #e5c07b
C_ERROR="\033[38;2;224;108;117m"      # #e06c75
C_RESET="\033[0m"

# Icons (Nerd Font)
ICON_CHECK=""
ICON_CROSS=""
ICON_ARROW=""
ICON_PACKAGE="󰏖"
ICON_FONT=""
ICON_CURSOR="󰍽"
ICON_CONFIG=""
ICON_INFO=""

_log() { printf "${C_TEXT}%s${C_RESET}\n" "$1"; }
_success() { printf "${C_SUCCESS}${ICON_CHECK} %s${C_RESET}\n" "$1"; }
_warn() { printf "${C_WARN}${ICON_INFO} %s${C_RESET}\n" "$1"; }
_error() { printf "${C_ERROR}${ICON_CROSS} %s${C_RESET}\n" "$1"; }
_header() { printf "\n${C_PRIMARY}${ICON_ARROW} %s${C_RESET}\n" "$1"; }

_expand_path() {
    echo "${1/#\~/$HOME}"
}

# ─────────────────────────────────────────────────────────────────────────────
# PACKAGE INSTALLATION
# ─────────────────────────────────────────────────────────────────────────────
install_packages() {
    _header "Installing apt packages"

    local packages
    packages=$(jq -r '.apt_packages[]' "$MANIFEST")
    local missing=()

    for pkg in $packages; do
        if ! dpkg -s "$pkg" &>/dev/null; then
            missing+=("$pkg")
        else
            printf "  ${C_MUTED}${ICON_PACKAGE} %s (installed)${C_RESET}\n" "$pkg"
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        _log "  Installing: ${missing[*]}"
        sudo apt-get update -qq
        sudo apt-get install -y -qq "${missing[@]}"
        _success "Packages installed"
    else
        _success "All packages already installed"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# FONT INSTALLATION
# ─────────────────────────────────────────────────────────────────────────────
install_fonts() {
    _header "Installing fonts"

    local font_names
    font_names=$(jq -r '.fonts | keys[]' "$MANIFEST")

    for font in $font_names; do
        local url target
        url=$(jq -r ".fonts[\"$font\"].url" "$MANIFEST")
        target=$(_expand_path "$(jq -r ".fonts[\"$font\"].target" "$MANIFEST")")

        # Check if font already installed
        if ls "$target"/*JetBrains*Mono*.ttf &>/dev/null 2>&1; then
            printf "  ${C_MUTED}${ICON_FONT} %s (installed)${C_RESET}\n" "$font"
            continue
        fi

        _log "  ${ICON_FONT} Downloading $font..."
        local tmpdir
        tmpdir=$(mktemp -d)

        curl -fsSL "$url" -o "$tmpdir/font.zip"
        unzip -q "$tmpdir/font.zip" -d "$tmpdir/extracted"

        mkdir -p "$target"
        find "$tmpdir/extracted" -name "*.ttf" -exec cp {} "$target/" \;

        rm -rf "$tmpdir"
        _success "$font installed"
    done

    # Rebuild font cache
    fc-cache -f &>/dev/null
    _success "Font cache updated"
}

# ─────────────────────────────────────────────────────────────────────────────
# CURSOR INSTALLATION
# ─────────────────────────────────────────────────────────────────────────────
install_cursors() {
    _header "Installing cursors"

    local cursor_names
    cursor_names=$(jq -r '.cursors | keys[]' "$MANIFEST")

    for cursor in $cursor_names; do
        local source target
        source="$SCRIPT_DIR/$(jq -r ".cursors[\"$cursor\"].source" "$MANIFEST")"
        target=$(_expand_path "$(jq -r ".cursors[\"$cursor\"].target" "$MANIFEST")")

        if [ -d "$target" ] && diff -rq "$source" "$target" &>/dev/null; then
            printf "  ${C_MUTED}${ICON_CURSOR} %s (installed)${C_RESET}\n" "$cursor"
            continue
        fi

        _log "  ${ICON_CURSOR} Installing $cursor..."
        mkdir -p "$(dirname "$target")"
        cp -r "$source" "$target"
        _success "$cursor installed"
    done

    # Set cursor theme via gsettings if available
    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.interface cursor-theme 'ComixCursorWhite' 2>/dev/null || true
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# CONFIG SYMLINKS
# ─────────────────────────────────────────────────────────────────────────────
install_configs() {
    _header "Symlinking configs"

    local config_names
    config_names=$(jq -r '.configs | keys[]' "$MANIFEST")

    for config in $config_names; do
        local source target method
        source="$SCRIPT_DIR/$(jq -r ".configs[\"$config\"].source" "$MANIFEST")"
        target=$(_expand_path "$(jq -r ".configs[\"$config\"].target" "$MANIFEST")")
        method=$(jq -r ".configs[\"$config\"].method" "$MANIFEST")

        # Check if source exists
        if [ ! -e "$source" ]; then
            printf "  ${C_WARN}${ICON_CONFIG} %s (source missing: %s)${C_RESET}\n" "$config" "$source"
            continue
        fi

        # Check if already correctly symlinked
        if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$source")" ]; then
            printf "  ${C_MUTED}${ICON_CONFIG} %s (linked)${C_RESET}\n" "$config"
            continue
        fi

        _log "  ${ICON_CONFIG} Linking $config..."
        mkdir -p "$(dirname "$target")"

        # Backup existing file if it exists and is not a symlink
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            mv "$target" "${target}.bak.$(date +%Y%m%d%H%M%S)"
            _warn "Backed up existing $target"
        fi

        # Remove existing symlink if pointing elsewhere
        [ -L "$target" ] && rm "$target"

        ln -s "$source" "$target"
        _success "$config linked"
    done
}

# ─────────────────────────────────────────────────────────────────────────────
# AUDIT
# ─────────────────────────────────────────────────────────────────────────────
audit() {
    _header "Auditing installation"
    local all_good=true

    # Check packages
    printf "\n${C_SECONDARY}Packages:${C_RESET}\n"
    for pkg in $(jq -r '.apt_packages[]' "$MANIFEST"); do
        if dpkg -s "$pkg" &>/dev/null; then
            printf "  ${C_SUCCESS}${ICON_CHECK}${C_RESET} %s\n" "$pkg"
        else
            printf "  ${C_ERROR}${ICON_CROSS}${C_RESET} %s (missing)\n" "$pkg"
            all_good=false
        fi
    done

    # Check fonts
    printf "\n${C_SECONDARY}Fonts:${C_RESET}\n"
    for font in $(jq -r '.fonts | keys[]' "$MANIFEST"); do
        local target
        target=$(_expand_path "$(jq -r ".fonts[\"$font\"].target" "$MANIFEST")")
        if ls "$target"/*JetBrains*Mono*.ttf &>/dev/null 2>&1; then
            printf "  ${C_SUCCESS}${ICON_CHECK}${C_RESET} %s\n" "$font"
        else
            printf "  ${C_ERROR}${ICON_CROSS}${C_RESET} %s (missing)\n" "$font"
            all_good=false
        fi
    done

    # Check cursors
    printf "\n${C_SECONDARY}Cursors:${C_RESET}\n"
    for cursor in $(jq -r '.cursors | keys[]' "$MANIFEST"); do
        local target
        target=$(_expand_path "$(jq -r ".cursors[\"$cursor\"].target" "$MANIFEST")")
        if [ -d "$target" ]; then
            printf "  ${C_SUCCESS}${ICON_CHECK}${C_RESET} %s\n" "$cursor"
        else
            printf "  ${C_ERROR}${ICON_CROSS}${C_RESET} %s (missing)\n" "$cursor"
            all_good=false
        fi
    done

    # Check configs
    printf "\n${C_SECONDARY}Configs:${C_RESET}\n"
    for config in $(jq -r '.configs | keys[]' "$MANIFEST"); do
        local source target
        source="$SCRIPT_DIR/$(jq -r ".configs[\"$config\"].source" "$MANIFEST")"
        target=$(_expand_path "$(jq -r ".configs[\"$config\"].target" "$MANIFEST")")

        if [ ! -e "$source" ]; then
            printf "  ${C_WARN}${ICON_INFO}${C_RESET} %s (source missing)\n" "$config"
        elif [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$source")" ]; then
            printf "  ${C_SUCCESS}${ICON_CHECK}${C_RESET} %s\n" "$config"
        elif [ -e "$target" ]; then
            printf "  ${C_WARN}${ICON_INFO}${C_RESET} %s (exists but not linked)\n" "$config"
            all_good=false
        else
            printf "  ${C_ERROR}${ICON_CROSS}${C_RESET} %s (missing)\n" "$config"
            all_good=false
        fi
    done

    printf "\n"
    if $all_good; then
        _success "All components installed correctly"
    else
        _warn "Some components need attention"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# LIST
# ─────────────────────────────────────────────────────────────────────────────
list_components() {
    printf "${C_PRIMARY}Managed Components${C_RESET}\n"
    printf "${C_MUTED}from %s${C_RESET}\n\n" "$MANIFEST"

    printf "${C_SECONDARY}${ICON_PACKAGE} Packages:${C_RESET}\n"
    for pkg in $(jq -r '.apt_packages[]' "$MANIFEST"); do
        printf "  - %s\n" "$pkg"
    done

    printf "\n${C_SECONDARY}${ICON_FONT} Fonts:${C_RESET}\n"
    for font in $(jq -r '.fonts | keys[]' "$MANIFEST"); do
        local url
        url=$(jq -r ".fonts[\"$font\"].url" "$MANIFEST")
        printf "  - %s\n    ${C_MUTED}%s${C_RESET}\n" "$font" "$url"
    done

    printf "\n${C_SECONDARY}${ICON_CURSOR} Cursors:${C_RESET}\n"
    for cursor in $(jq -r '.cursors | keys[]' "$MANIFEST"); do
        local target
        target=$(jq -r ".cursors[\"$cursor\"].target" "$MANIFEST")
        printf "  - %s -> %s\n" "$cursor" "$target"
    done

    printf "\n${C_SECONDARY}${ICON_CONFIG} Configs:${C_RESET}\n"
    for config in $(jq -r '.configs | keys[]' "$MANIFEST"); do
        local source target
        source=$(jq -r ".configs[\"$config\"].source" "$MANIFEST")
        target=$(jq -r ".configs[\"$config\"].target" "$MANIFEST")
        printf "  - %s\n    ${C_MUTED}%s -> %s${C_RESET}\n" "$config" "$source" "$target"
    done
}

# ─────────────────────────────────────────────────────────────────────────────
# HELP
# ─────────────────────────────────────────────────────────────────────────────
show_help() {
    cat <<EOF
${C_PRIMARY}Dotfiles Bootstrap${C_RESET}

${C_SECONDARY}Usage:${C_RESET}
  ./install.sh           Full install (idempotent)
  ./install.sh --audit   Check installation status
  ./install.sh --list    Show all managed components
  ./install.sh --help    Show this help

${C_SECONDARY}What it does:${C_RESET}
  1. Installs apt packages (curl, git, jq, etc.)
  2. Downloads JetBrainsMono Nerd Font from GitHub
  3. Copies cursor theme to ~/.icons/
  4. Symlinks configs to their target locations

${C_SECONDARY}Idempotent:${C_RESET}
  Safe to run multiple times. Skips already-installed components.
EOF
}

# ─────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────
main() {
    case "${1:-}" in
        --audit|-a)
            audit
            ;;
        --list|-l)
            list_components
            ;;
        --help|-h)
            show_help
            ;;
        --update|-u|"")
            printf "${C_PRIMARY}░▒▓ Dotfiles Bootstrap${C_RESET}\n"
            printf "${C_MUTED}%s${C_RESET}\n" "$SCRIPT_DIR"

            install_packages
            install_fonts
            install_cursors
            install_configs

            printf "\n${C_SUCCESS}${ICON_CHECK} Installation complete${C_RESET}\n"
            printf "${C_MUTED}Run './install.sh --audit' to verify${C_RESET}\n"
            ;;
        *)
            _error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
