#!/usr/bin/env bash
set -euo pipefail

DOTFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

link() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ]; then
        if [ "$(readlink "$dst")" = "$src" ]; then
            echo "  ok    $dst"
            return
        fi
        rm "$dst"
    elif [ -e "$dst" ]; then
        local backup="${dst}.backup-${TIMESTAMP}"
        mv "$dst" "$backup"
        echo "  backup  $dst -> $backup"
    fi

    ln -s "$src" "$dst"
    echo "  link  $dst -> $src"
}

echo "Installing dotfiles from $DOTFILE_DIR"

link "$DOTFILE_DIR/claude/settings.json" "$HOME/.claude/settings.json"
link "$DOTFILE_DIR/zellij/config.kdl"    "$HOME/.config/zellij/config.kdl"

echo "Done."
