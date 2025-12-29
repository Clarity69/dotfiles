#!/bin/bash
# ── power-profile.sh ──────────────────────────────────────
# Description: Display current Power Profile with color
# Usage: Called by Waybar
# Dependencies: power-profiles-daemon (powerprofilesctl)
# ──────────────────────────────────────────────────────────

# Mengambil profil aktif (output biasanya: performance, balanced, atau power-saver)
profile=$(powerprofilesctl get)

# Membersihkan output (menghapus whitespace jika ada)
profile=$(echo "$profile" | tr -d '[:space:]')

case "$profile" in
  performance)
    text="RAZGON"
    fg="#bf616a"  # Merah/Nord Red
    ;;
  balanced)
    text="STABILIZATION"
    fg="#fab387"  # Orange/Peach
    ;;
  power-saver)
    text="REACTOR SLEEP"
    fg="#56b6c2"  # Cyan/Teal
    ;;
  *)
    text="UNKNOWN: $profile"
    fg="#ffffff"
    ;;
esac

# Output format pango markup untuk Waybar
echo "<span foreground='$fg'>$text</span>"