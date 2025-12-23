#!/bin/bash

# --- Konfigurasi Path ---
DOT_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "Starting...."

# 1. Buat folder tujuan jika belum ada
mkdir -p "$CONFIG_DIR"
mkdir -p "$BIN_DIR"

# 2. Fungsi untuk Backup dan Link
install_link() {
    local src=$1
    local dest=$2

    if [ -e "$dest" ]; then
        echo "Backup $dest ke $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR/"
    fi

    echo "🔗 Link  $src -> $dest"
    ln -sf "$src" "$dest"
}

# --- A. Install Konfigurasi (~/.config) ---
echo -e "\n--- Setting Config (.config) ---"
folders=("hypr" "waybar" "wal" "kitty" "rofi" "spicetify" "swaync")

for folder in "${folders[@]}"; do
    if [ -d "$DOT_DIR/config/$folder" ]; then
        install_link "$DOT_DIR/config/$folder" "$CONFIG_DIR/$folder"
    fi
done

# Khusus Vencord (hanya tema)
mkdir -p "$CONFIG_DIR/Vencord/themes"
install_link "$DOT_DIR/config/Vencord/themes/midnight.theme.css" "$CONFIG_DIR/Vencord/themes/midnight.theme.css"

# --- B. Install Scripts (~/.local/bin) ---
echo -e "\n--- Setting Scripts (~/.local/bin) ---"
# Daftar script yang ingin di-link secara spesifik
scripts=("wallet" "wallset-backend")

for script in "${scripts[@]}"; do
    if [ -f "$DOT_DIR/bin/$script" ]; then
        install_link "$DOT_DIR/bin/$script" "$BIN_DIR/$script"
        chmod +x "$BIN_DIR/$script"
    fi
done

# --- C. Finalisasi ---
echo -e "\n-------------------------------------------------------"
echo "✅ Done"
echo "💡 Tips: Jalankan 'wallset-backend [path_gambar]' untuk sinkronisasi warna."
echo "💡 Info: Backup konfigurasi lamamu ada di $BACKUP_DIR"
echo "-------------------------------------------------------"
