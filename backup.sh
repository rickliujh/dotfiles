#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu
source ./helper.sh

BACKUP_DIR="$HOME/.local/state/dotfiles/backups"
CURRENT_TIME=$(date "+%Y-%m-%d_%H-%M-%S")

backup_configs() {
    log_task "Backing up existing files..."
    NEW_BACKUP_DIR="$BACKUP_DIR/$CURRENT_TIME"
    mkdir -p "$NEW_BACKUP_DIR" 

    dirs=($(config_dirs))
    for dir in "${dirs[@]}"; do
        if [ -d "$HOME/.config/$dir" ]; then
            mkdir -p "$NEW_BACKUP_DIR/.config" 
            mv -v "$HOME/.config/$dir" "$NEW_BACKUP_DIR/.config/$dir"
        fi
    done

    files=($(config_files))
    for file in "${files[@]}"; do
        if [ -f "$HOME/$file" ]; then
            mv -v "$HOME/$file" "$NEW_BACKUP_DIR/$file"
        fi
    done

    log_manual_action "You can remove backups in $NEW_BACKUP_DIR"
}

