#!/bin/bash

# -e: exit on error
# -u: exit on unset variables
set -eu
source "$(dirname "${BASH_SOURCE[0]}")/helper.sh"

# home/ mirrors $HOME. Every entry in it is symlinked to the same place under
# $HOME, as a whole: a file as a file, a directory (home/.config/nvim) as a
# directory, so anything added inside it later is already in the repo.
#
# The exception is the directories below, which are shared with other programs
# and must stay real directories: those are descended into, and their entries
# are linked one by one instead. Linking one of them as a whole would make every
# program that writes there (shell history, credentials, caches) write into
# this repo.
#
# Adding a file or directory under home/ needs no change here. Only a new
# shared directory (say ~/.codex) needs adding to this list.
SHARED=(.config .local .local/bin .claude)

BACKUP_DIR="$HOME/.local/state/dotfiles/backups"
CURRENT_TIME=$(date "+%Y-%m-%d_%H-%M-%S")
NEW_BACKUP_DIR="$BACKUP_DIR/$CURRENT_TIME"

is_shared() {
    local dir
    for dir in "${SHARED[@]}"; do
        [ "$dir" = "$1" ] && return 0
    done
    return 1
}

# Calls `$1 <repo path> <home path> <path relative to home>` for every entry of
# home/ that gets linked. $2 is the shared directory being descended into.
# Runs in a subshell so the glob options do not leak into the installers.
walk_home() (
    shopt -s dotglob nullglob
    action=$1
    rel=${2:-}
    for item in "$DOTFILES_DIR/home${rel:+/$rel}"/*; do
        name="${rel:+$rel/}$(basename "$item")"
        if [ -d "$item" ] && is_shared "$name"; then
            # A shared directory that is itself a link into this repo (left by
            # an older layout) would make the links below land inside the repo.
            if [ -L "$HOME/$name" ] && [[ $(readlink -f "$HOME/$name") == "$DOTFILES_DIR"/* ]]; then
                rm -v "$HOME/$name"
            fi
            mkdir -p "$HOME/$name"
            walk_home "$action" "$name"
        else
            "$action" "$item" "$HOME/$name" "$name"
        fi
    done
)

# Moves a real file or directory out of the way. A symlink holds nothing of its
# own, so it is left for link_one to replace.
backup_one() {
    local target=$2 name=$3
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$(dirname "$NEW_BACKUP_DIR/$name")"
        mv -v "$target" "$NEW_BACKUP_DIR/$name"
    fi
}

link_one() {
    backup_one "$@"
    ln -sfnv "$1" "$2"
}

report_backups() {
    if [ -d "$NEW_BACKUP_DIR" ]; then
        log_manual_action "You can remove backups in $NEW_BACKUP_DIR"
    fi
}

backup_configs() {
    log_task "Backing up existing files..."
    walk_home backup_one
    report_backups
}

setup_symlinks() {
    log_task "Setting up symlinks..."
    walk_home link_one
    report_backups
}
