#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu
source ./helper.sh

setup_symlinks() {
    log_task "Setting up symlinks..."
    for dir in "${config_dirs[@]}"; do
        ln -sfnv "$PWD/config/$dir" "$HOME/.config/"
    done
    for file in "${home_files[@]}"; do
        ln -sfnv "$PWD/config/$file" ~/
    done
}
