#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu
source ./helper.sh

declare -a config_dirs=(
    "autorandr" "bat" "broot" "bundle" "cmus" "delta" "fish" "fontconfig" "gitignore.global"
    "htop" "kitty" "lazygit" "xplr" "libinput-gestures.conf" "ranger" "shell"
    "sysinfo.conkyrc" "topgrade.toml" "bluetuith" "nvim"
)

declare -a home_files=(
    ".bashrc" ".dircolors" ".dmenurc" ".gitconfig" ".inputrc" ".luarc.json" ".prettierrc"
    ".pryrc" ".pystartup" ".stylua.toml" ".tmux.conf" ".vimrc" ".Xresources" ".zshrc"
)

backup_configs() {
    log_task "Backing up existing files..."

    for dir in "${config_dirs[@]}"; do
        mv -v "$HOME/.config/$dir" "$HOME/.config/$dir.old"
    done
    for file in "${home_files[@]}"; do
        mv -v "$HOME/$file" "$HOME/$file.old"
    done

    log_manual_action "Remove backups with 'rm -ir ~/.*.old && rm -ir ~/.config/*.old'."
}
