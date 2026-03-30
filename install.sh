#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"
MODULES=(git ghostty btop yazi starship claude)

usage() {
    echo "用法: $0 [模块名]"
    echo ""
    echo "不带参数则安装全部模块，指定模块名则只安装该模块。"
    echo ""
    echo "可用模块:"
    for m in "${MODULES[@]}"; do echo "  $m"; done
    exit 0
}

[ "$1" = "-h" ] || [ "$1" = "--help" ] && usage
TARGET="$1"

link_file() {
    local src="$1" dst="$2"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        backup="$dst.bak.$(date +%Y%m%d%H%M%S)"
        echo "备份 $dst -> $backup"
        mv "$dst" "$backup"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
    echo "链接 $dst -> $src"
}

should_install() {
    [ -z "$TARGET" ] || [ "$1" = "$TARGET" ]
}

# git: ~/.gitconfig + ~/.config/git/ignore
if should_install git; then
    link_file "$DOTFILES_DIR/git/config" "$HOME/.gitconfig"
    link_file "$DOTFILES_DIR/git" "$CONFIG_DIR/git"
fi

# ghostty
if should_install ghostty; then
    link_file "$DOTFILES_DIR/ghostty" "$CONFIG_DIR/ghostty"
fi

# btop
if should_install btop; then
    link_file "$DOTFILES_DIR/btop" "$CONFIG_DIR/btop"
fi

# yazi
if should_install yazi; then
    link_file "$DOTFILES_DIR/yazi" "$CONFIG_DIR/yazi"
fi

# starship
if should_install starship; then
    link_file "$DOTFILES_DIR/starship.toml" "$CONFIG_DIR/starship.toml"
fi

# claude
if should_install claude; then
    link_file "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
    link_file "$DOTFILES_DIR/claude/agents" "$HOME/.claude/agents"
fi

echo "done!"
