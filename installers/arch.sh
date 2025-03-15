#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu

log_task "loading arch.sh"

install_essentials() {
    # considering indtall
    # bat https://github.com/sharkdp/bat
    # fzf https://github.com/junegunn/fzf
    # eza https://github.com/eza-community/eza
    # ripgrep/rg https://github.com/BurntSushi/ripgrep
    # ncdu https://github.com/rofl0r/ncdu
    # ranger https://github.com/ranger/ranger
    # zoxided https://github.com/ajeetdsouza/zoxide
    # fd-find https://github.com/sharkdp/fd
    # lazygit https://github.com/jesseduffield/lazygit

    log_task "Checking updates..."
    log_task "Installing..."
    yes | sudo pacman -S btop zsh ripgrep fd-find curl wget git tmux bat fzf unzip vim lsof tree

    sudo ln -sfnv /usr/bin/fdfind /usr/bin/fd
    sudo ln -sfnv /usr/bin/batcat /usr/bin/bat
}

install_nvim() {
    log_task "Installing NEOVIM..."
    yes | sudo pacman -S neovim
}

install_git_delta() {
    log_task "Installing git-delta..."
    yes | sudo pacman -S git-delta
}

install_go() {
    log_task "Installing golang..."
    yes | sudo pacman -S go
}

install_rust() {
    log_task "Installing rust lang..."

    yes | sudo pacman -S rustup
    rustup --no-modify-path -y

    source "$HOME/.cargo/env" 

    # rust toolchain auto completions
    echo 'eval "$(rustup completions zsh rustup)"' >> ~/.local.sh
    echo 'eval "$(rustup completions zsh cargo )"' >> ~/.local.sh
}

install_python3() {
    yes | sudo pacman -S python3 python-uv

    # uv auto completions
    echo 'eval "$(uv generate-shell-completion zsh)"' >> ~/.local.sh
    echo 'eval "$(uvx --generate-shell-completion zsh)"' >> ~/.local.sh
}

install_node() {
    yes | sudo pacman -S nodejs
    sudo corepack enable
}

install_dev_pkgs() {
    yes | sudo pacman -S base-devel
}

install_docker() {
    yes | sudo pacman -S docker
}

install_sysbox() {
    yay -ScR --answerclean All --answerdiff All --answeredit All --answerupgrade Repo sysbox-ce-bin
    # to uninstall, see: https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install-package.md#uninstallation
}
