#!/bin/bash

# Kill all running waybar
killall -9 waybar
killall -9 swaync

# Small delay biar proses dari pkill selesai
sleep 0.2

# Start waybar lagi
swaync
waybar
