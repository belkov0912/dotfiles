#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"

# 需要链接的目录/文件: 源(相对dotfiles) -> 目标(相对~/.config)
links=(
    "ghostty:ghostty"
    "btop:btop"
    "yazi:yazi"
    "git:git"
    "starship.toml:starship.toml"
)

# ~/.claude 下的文件: 源(相对dotfiles/claude) -> 目标(相对~/.claude)
claude_links=(
    "settings.json:settings.json"
    "agents:agents"
)

for entry in "${claude_links[@]}"; do
    src="$DOTFILES_DIR/claude/${entry%%:*}"
    dst="$HOME/.claude/${entry##*:}"

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        backup="$dst.bak.$(date +%Y%m%d%H%M%S)"
        echo "备份 $dst -> $backup"
        mv "$dst" "$backup"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
    echo "链接 $dst -> $src"
done

for entry in "${links[@]}"; do
    src="$DOTFILES_DIR/${entry%%:*}"
    dst="$CONFIG_DIR/${entry##*:}"

    # 如果目标已存在且不是符号链接，备份它
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        backup="$dst.bak.$(date +%Y%m%d%H%M%S)"
        echo "备份 $dst -> $backup"
        mv "$dst" "$backup"
    fi

    # 确保父目录存在
    mkdir -p "$(dirname "$dst")"

    # 创建符号链接（-f 覆盖已有链接）
    ln -sfn "$src" "$dst"
    echo "链接 $dst -> $src"
done

echo "done!"
