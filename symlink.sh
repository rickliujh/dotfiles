#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu
source ./helper.sh

setup_symlinks() {
    log_task "Setting up symlinks..."

    mkdir -p "$HOME/.config/" 
    mkdir -p "$HOME/.local/bin" 
    dirs=($(config_dirs))
    files=($(config_files))
    scripts=($(config_scripts))

    for dir in "${dirs[@]}"; do
        ln -sfnv "$PWD/config/$dir" "$HOME/.config/"
    done
    for file in "${files[@]}"; do
        ln -sfnv "$PWD/config/$file" "$HOME/"
    done
    for script in "${scripts[@]}"; do
        ln -sfnv "$PWD/scripts/$script" "$HOME/.local/bin"
        chmod 755 "$PWD/scripts/$script"
    done
}

