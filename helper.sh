#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu

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

config_dirs() {
    declare -a config_dirs
    for item in "$PWD"/config/*; do
        if [ -d "$item" ]; then
            dir=$(basename "$item")
	    config_dirs+=($dir)
	fi 
    done    
    echo ${config_dirs[@]}
 }

config_files() {
    declare -a config_files
    for item in "$PWD"/config/.*; do
        if [ -f "$item" ]; then
            file=$(basename "$item")
	    config_files+=($file)
       	fi 
    done    
    echo ${config_files[@]}
 }

config_scripts() {
    declare -a scripts
    for item in "$PWD"/scripts/*; do
            script=$(basename "$item")
	    scripts+=($script)
    done    
    echo ${scripts[@]}
 }

check_lang_installed() {
    go version && rustc --version || error "Install essential languages first"
}

