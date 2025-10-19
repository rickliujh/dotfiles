#!/bin/bash

# -e: exit on error
# -u: exit on unset variables
set -eu

log_task "loading mac.sh"

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
    brew install btop zsh ripgrep fd curl wget git tmux bat fzf unzip vim lsof tree
}

install_nvim() {
    log_task "Installing NEOVIM..."
    brew install neovim
}

install_git_delta() {
    log_task "Installing git-delta..."
    brew install git-delta
}

install_go() {
    log_task "Installing golang..."
    brew install go
}

install_python3() {
    log_task "Installing Python3 and uv..."

    brew install python3 uv

    # for uv auto completions call f_eval_comp
}

install_node() {
    log_task "Installing node..."

    brew install nodejs
    sudo corepack enable
}

install_dev_pkgs() {
    xcode-select --install
}

install_docker() {
    log_task "Installing docker..."

    brew install --cask docker
}

install_sysbox() {
    log_task "Installing sysbox-runc from AUR..."

    log_error "installing sysbox in macos is not supported"
}

install_eza() {
    log_blue "Installing eza..."
    brew install eza
}

install_tobgrade() {
    log_blue "Installing topgrade from AUR..."
    brew install topgrade
}

install_lazygit() {
    log_blue "Installing lazygit..."
    brew install lazygit
}

install_zoxide() {
    log_blue "Installing zoxide..."
    brew install zoxide

    if [ ! -f "~/.local_sh" ]; then
        touch ~/.local.sh
    fi
    cat << 'EOF' >> ~/.local.sh

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
else
  return 1
fi
EOF
}
 
