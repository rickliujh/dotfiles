#!/bin/bash

# -e: exit on error
# -u: exit on unset variables
set -eu

# Repo root, so the scripts work from any directory.
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

log_color() {
    color_code="$1"
    shift

    printf "\033[${color_code}m%s\033[0m\n" "$*" >&2
}

log() {
    echo "$@"
}

log_red() {
    log_color "0;31" "$@"
}

log_blue() {
    log_color "0;34" "$@"
}

log_task() {
    log_blue "🔃" "$@"
}

log_manual_action() {
    log_red "⚠️" "$@"
}

log_error() {
    log_red "❌" "$@"
}

error() {
    log_error "$@"
    exit 1
}

sudo() {
    # shellcheck disable=SC2312
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    else
        if ! command sudo --non-interactive true 2>/dev/null; then
            log_manual_action "Root privileges are required, please enter your password below"
            command sudo --validate
        fi
        command sudo "$@"
    fi
}

check_lang_installed() {
    go version && rustc --version || error "Install essential languages first"
}

PREZTO_COMP=$HOME/.zprezto/modules/completion/external/src

touch_zsh_completion() {
    filename=$1
    cat > "$PREZTO_COMP/$filename"
}
