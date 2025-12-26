#!/usr/bin/env bash

BASE="$HOME/.config/waybar"
LAYOUT_DIR="$BASE/layouts"

# Ambil nama layout (tanpa .json)
OPTIONS=$(ls "$LAYOUT_DIR" | sed 's/\.json$//')

CHOSEN=$(echo "$OPTIONS" | rofi -dmenu -p "Waybar Layout")

[[ -z "$CHOSEN" ]] && exit 0

# Validasi file ada
[[ ! -f "$BASE/layouts/$CHOSEN.json" ]] && exit 1
[[ ! -f "$BASE/styles/$CHOSEN.css" ]] && exit 1

# Switch
ln -sf "$BASE/layouts/$CHOSEN.json" "$BASE/config"
ln -sf "$BASE/styles/$CHOSEN.css" "$BASE/style.css"

pkill waybar
waybar &
