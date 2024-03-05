#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu
source ./helper.sh
source ./installer.sh
source ./backup.sh
source ./symlink.sh

setup_ssh() {
    log_task "Setting up SSH key for you..."
    log_manual_action "Enther your email: "
    read email
    ssh-keygen -t ed25519 -C "$email"
    eval `ssh-agent -s`
    ssh-add "$HOME/.ssh/id_ed25519"
}

setup_all() {
    install_all 
    backup_configs 
    setup_symlinks 
    setup_ssh
}

show_menu() {
    echo -e "\u001b[32;1m Setting up your env with dots2k...\u001b[0m"
    echo -e " \u001b[37;1m\u001b[4mSelect an option:\u001b[0m"
    echo -e "  \u001b[34;1m (0) Setup Everything \u001b[0m"
    echo -e "  \u001b[34;1m (1) Install Packages \u001b[0m"
    echo -e "  \u001b[34;1m (2) Install Languages \u001b[0m"
    echo -e "  \u001b[34;1m (3) Install Extras \u001b[0m"
    echo -e "  \u001b[34;1m (4) Backup Configs \u001b[0m"
    echo -e "  \u001b[34;1m (5) Setup Symlinks \u001b[0m"
    echo -e "  \u001b[31;1m (*) Anything else to exit \u001b[0m"
    echo -en "\u001b[32;1m ==> \u001b[0m"

    read -r option
    case $option in
    "0") setup_all ;;
    "1") install_without_languages ;;
    "2") install_languages ;;
    "3") install_extras ;;
    "4") backup_configs ;;
    "5") setup_symlinks ;;
    *) echo -e "\u001b[31;1m alvida and adios! \u001b[0m" && exit 0 ;;
    esac
}

main() {
    case "$1" in
    -a | --all | a | all) setup_all ;;
    -i | --install | i | install) install_packages && install_languages ;;
    -l | --symlinks | l | symlinks) setup_symlinks ;;
    -b | --backup | b | backup) backup_configs ;;
    *) "$@";;
    esac
    exit 0
}

main "$@"
