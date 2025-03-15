#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu

source ../helper.sh
source /etc/os-release

case $ID_LIKE in
  debian) 
    log_blue "Detected Debian Base System"
    source ./deb.sh
    ;;
  arch) 
    log_blue "Detected Arch Base System"
    source ./arch.sh
    ;;
  *) 
    log_error "Operation aborted: Unknown distribution"
    exit 1
    ;;
esac

install_extras() {
    log_task "Installing extra package..."
    check_lang_installed

    cargo install eza
    cargo install topgrade 
    go install github.com/jesseduffield/lazygit@latest
    install_docker
    install_sysbox
}

install_without_languages() {
    install_essentials
    install_nvim
    install_oh_my_zsh
    install_git_delta
    install_tmux_plugin
}

install_languages() {
    install_go
    install_rust
    install_python3
    install_dev_pkgs
}

install_all() {
    install_without_languages
    install_languages
    install_extras
}
