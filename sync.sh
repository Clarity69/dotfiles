#!/usr/bin/env bash
# Salin config yang sedang dipakai di laptop ke repo ini.
#   ./sync.sh          sync semua isi dots.list + pin submodule My-Shell
#   ./sync.sh -n       dry run, cuma lihat apa yang berubah
# Setelah itu tinggal: git add -A && git commit && git push

set -euo pipefail

DOT_DIR="$(cd "$(dirname "$0")" && pwd)"
DRY=""
[ "${1:-}" = "-n" ] && DRY="--dry-run"

live_path() {
    case "$1" in
        config/*) echo "$HOME/.config/${1#config/}" ;;
        bin/*)    echo "$HOME/.local/bin/${1#bin/}" ;;
    esac
}

while read -r entry; do
    entry="${entry%%#*}"; entry="$(echo "$entry" | xargs)"
    [ -z "$entry" ] && continue

    src="$(live_path "$entry")"
    dst="$DOT_DIR/$entry"

    if [ ! -e "$src" ]; then
        echo "  skip   $entry (tidak ada di laptop)"
        continue
    fi
    # Sudah di-symlink ke repo ini = tidak perlu disalin
    if [ "$(realpath "$src")" = "$(realpath -m "$dst")" ]; then
        echo "  linked $entry"
        continue
    fi

    echo "  sync   $entry"
    [ -n "$DRY" ] && continue

    rm -rf "$dst"
    mkdir -p "$(dirname "$dst")"
    if [ -d "$src" ]; then
        cp -a "$src" "$dst"
        # Buang yang tidak perlu masuk repo
        find "$dst" \( -name .git -o -name backup -o -name Backup -o -name __pycache__ -o -name node_modules \) \
            -prune -exec rm -rf {} +
        find "$dst" -type f \( -name '*.bak' -o -name '*.log' -o -name '*.tmp' \) -delete
        # Symlink ke luar folder diganti file aslinya, kecuali yang ke ~/.cache
        # (mis. warna pywal) dibiarkan tetap symlink supaya tetap ikut wallpaper
        find "$dst" -type l | while read -r l; do
            case "$(readlink "$l")" in "$HOME/.cache/"*) continue ;; esac
            target="$(readlink -f "$l" || true)"
            case "$target" in "$(realpath "$src")"/*) continue ;; esac
            rm "$l"
            [ -e "$target" ] && cp -aL "$target" "$l"
        done
    else
        cp -aL "$src" "$dst"
    fi
done < "$DOT_DIR/dots.list"

# ── My-Shell (submodule) ─────────────────────────────────────────────
# Submodule dipin ke commit yang sedang dipakai di ~/.config/quickshell/shell
SHELL_LIVE="$HOME/.config/quickshell/shell"
SHELL_SUB="$DOT_DIR/config/quickshell/shell"

if [ -d "$SHELL_LIVE/.git" ] && [ -e "$SHELL_SUB/.git" ] \
   && [ "$(realpath "$SHELL_LIVE")" != "$(realpath "$SHELL_SUB")" ]; then
    if [ -n "$(git -C "$SHELL_LIVE" status --porcelain)" ]; then
        echo "  ! My-Shell punya perubahan yang belum di-commit, commit + push dulu di $SHELL_LIVE"
    fi
    sha="$(git -C "$SHELL_LIVE" rev-parse HEAD)"
    if git -C "$SHELL_LIVE" branch -r --contains "$sha" 2>/dev/null | grep -q .; then
        echo "  pin    config/quickshell/shell -> ${sha:0:7}"
        if [ -z "$DRY" ]; then
            git -C "$SHELL_SUB" fetch -q origin
            git -C "$SHELL_SUB" checkout -q "$sha"
        fi
    else
        echo "  ! commit ${sha:0:7} My-Shell belum di-push, submodule tidak diubah"
    fi
fi

echo
git -C "$DOT_DIR" status --short | head -40
