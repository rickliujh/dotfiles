#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu

readonly CURR_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $CURR_DIR/../helper.sh
source $CURR_DIR/./default.sh
source /etc/os-release

case $ID_LIKE in
  debian) 
    log_blue "Detected Debian Base System"
    source $CURR_DIR/./deb.sh
    ;;
  arch) 
    log_blue "Detected Arch Base System"
    source $CURR_DIR/./arch.sh
    ;;
  *) 
    log_error "Operation aborted: Unknown distribution"
    exit 1
    ;;
esac

install_extras() {
    log_task "Installing extra package..."
    check_lang_installed

    install_docker
    install_sysbox
    install_eza
    install_tobgrade
    install_lazygit
}

install_without_languages() {
    install_essentials
    install_nvim
    install_prezto
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
