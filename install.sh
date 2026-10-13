#!/usr/bin/env bash
# Pasang dotfiles ke laptop baru: symlink isi dots.list ke ~/.config dan ~/.local/bin.
#   ./install.sh           symlink saja (yang lama dibackup dulu)
#   ./install.sh --deps    install paket dulu, lalu symlink
#   ./install.sh -n        dry run

set -euo pipefail

DOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
DRY=0; DEPS=0
for a in "$@"; do
    case "$a" in
        -n) DRY=1 ;;
        --deps) DEPS=1 ;;
    esac
done

run() { if [ $DRY = 1 ]; then echo "    $*"; else "$@"; fi; }

# ── Paket ────────────────────────────────────────────────────────────
PKGS=(
    hyprland hyprlock hyprsunset xdg-desktop-portal-hyprland
    quickshell kitty rofi python-pywal awww
    networkmanager bluez bluez-utils wireplumber brightnessctl
    power-profiles-daemon upower cliphist wl-clipboard grim slurp
    github-cli jq curl ttf-jetbrains-mono-nerd
)

if [ $DEPS = 1 ]; then
    echo "--- Paket"
    if command -v paru >/dev/null;  then run paru -S --needed "${PKGS[@]}"
    elif command -v yay >/dev/null; then run yay -S --needed "${PKGS[@]}"
    else
        echo "  paru/yay tidak ada; paket AUR (mis. awww) perlu dipasang manual"
        run sudo pacman -S --needed "${PKGS[@]}" || true
    fi
fi

# ── Symlink ──────────────────────────────────────────────────────────
live_path() {
    case "$1" in
        config/*) echo "$HOME/.config/${1#config/}" ;;
        bin/*)    echo "$HOME/.local/bin/${1#bin/}" ;;
    esac
}

link() {
    local src="$1" dest="$2"
    if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
        echo "  ok     ${dest/#$HOME/\~}"
        return
    fi
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "  backup ${dest/#$HOME/\~}"
        run mkdir -p "$BACKUP_DIR/$(dirname "${dest#$HOME/}")"
        run mv "$dest" "$BACKUP_DIR/${dest#$HOME/}"
    fi
    echo "  link   ${dest/#$HOME/\~}"
    run mkdir -p "$(dirname "$dest")"
    run ln -s "$src" "$dest"
}

echo "--- Submodule"
run git -C "$DOT_DIR" submodule update --init --recursive

echo "--- Config"
while read -r entry; do
    entry="${entry%%#*}"; entry="$(echo "$entry" | xargs)"
    [ -z "$entry" ] && continue
    [ -e "$DOT_DIR/$entry" ] || continue
    link "$DOT_DIR/$entry" "$(live_path "$entry")"
    [[ "$entry" == bin/* ]] && run chmod +x "$DOT_DIR/$entry"
done < "$DOT_DIR/dots.list"

# My-Shell: symlink ke submodule
[ -e "$DOT_DIR/config/quickshell/shell/shell.qml" ] && \
    link "$DOT_DIR/config/quickshell/shell" "$HOME/.config/quickshell/shell"

# Wallpaper bawaan repo, kalau belum punya folder sendiri
[ -e "$HOME/Pictures/Wallpaper" ] || link "$DOT_DIR/Wallpaper" "$HOME/Pictures/Wallpaper"

# Hyprland butuh file ini ada (ditulis halaman Appearance di Control Center)
[ -e "$HOME/.config/hypr/quickshell.conf" ] || run touch "$HOME/.config/hypr/quickshell.conf"

echo
echo "Selesai."
[ -d "$BACKUP_DIR" ] && echo "Config lama ada di $BACKUP_DIR"
echo "Pilih wallpaper pertama: wallset-backend ~/Pictures/Wallpaper/<gambar>"
