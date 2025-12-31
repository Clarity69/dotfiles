#!/usr/bin/env bash

# Path ikon (sesuaikan dengan folder swaync kamu)
iDIR="$HOME/.config/swaync/icons"

# Fungsi mendapatkan volume speaker
get_volume() {
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
    muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep "MUTED")
    if [[ -n "$muted" ]]; then
        echo "Muted"
    else
        echo "${volume%.*}%"
    fi
}

# Fungsi toggle mute mic
toggle_mic() {
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    status=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
    if [[ $status == *"[MUTED]"* ]]; then
        notify-send -e -u low -i "$iDIR/microphone-mute.png" "Microphone Switched OFF"
    else
        notify-send -e -u low -i "$iDIR/microphone.png" "Microphone Switched ON"
    fi
}

# Fungsi tambah volume mic
inc_mic_volume() {
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0
    wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+
    notify-send -u low "Mic-Level: $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $2 * 100}%')"
}

# Fungsi kurang volume mic
dec_mic_volume() {
    wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-
    notify-send -u low "Mic-Level: $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $2 * 100}%')"
}

# Fungsi toggle mute speaker
toggle_mute() {
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    if [[ $status == *"[MUTED]"* ]]; then
        notify-send -e -u low "Volume Switched OFF"
    else
        notify-send -e -u low "Volume Switched ON"
    fi
}

# Execute
case "$1" in
    "--get") get_volume ;;
    "--inc") wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
    "--dec") wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    "--toggle") toggle_mute ;;
    "--toggle-mic") toggle_mic ;;
    "--mic-inc") inc_mic_volume ;;
    "--mic-dec") dec_mic_volume ;;
    *) get_volume ;;
esac