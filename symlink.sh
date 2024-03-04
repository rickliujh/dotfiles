#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu
source ./helper.sh

setup_symlinks() {
    log_task "Setting up symlinks..."
    for item in "$PWD/config"; do
        if [ -d "$item" ]; then
            ln -sfnv "$PWD/config/$item" "$HOME/.config/"
        done
        if [ -f "$item" ]; then
            ln -sfnv "$PWD/config/$item" ~/
        done
    done
}
