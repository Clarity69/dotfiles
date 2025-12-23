#!/usr/bin/env bash

# === Config ===
ROFI_CMD="rofi -dmenu -i -p Bluetooth"
BTCTL="bluetoothctl"

# Pastikan bluetooth aktif
power_status=$($BTCTL show | grep "Powered" | awk '{print $2}')
if [[ "$power_status" == "no" ]]; then
    $BTCTL power on >/dev/null
    sleep 1
fi

# Ambil device list
devices=$($BTCTL devices | sed 's/^Device //')

choice=$(echo "$devices" | $ROFI_CMD)
[[ -z "$choice" ]] && exit 0

mac=$(echo "$choice" | awk '{print $1}')
name=$(echo "$choice" | cut -d' ' -f2-)

connected=$($BTCTL info "$mac" | grep "Connected" | awk '{print $2}')

if [[ "$connected" == "yes" ]]; then
    $BTCTL disconnect "$mac"
    notify-send "Bluetooth" "Disconnected from $name"
else
    $BTCTL connect "$mac"
    notify-send "Bluetooth" "Connected to $name"
fi
