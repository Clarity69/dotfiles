#!/usr/bin/env bash

# Parameter $1 berisi path wallpaper yang dipassing oleh hyprquickpaper
SELECTED_WALL="$1"

if [ -n "$SELECTED_WALL" ]; then
    ~/.local/bin/wallset-backend "$SELECTED_WALL"
fi