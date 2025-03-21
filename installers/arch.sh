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
    yes | sudo pacman -S btop zsh ripgrep fd curl wget git tmux bat fzf unzip vim lsof tree
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

install_python3() {
    log_task "Installing Python3 and uv..."

    yes | sudo pacman -S python3 python-uv

    # for uv auto completions call f_eval_comp
}

install_node() {
    log_task "Installing node..."

    yes | sudo pacman -S nodejs
    sudo corepack enable
}

install_dev_pkgs() {
    yes | sudo pacman -S base-devel
}

install_docker() {
    log_task "Installing docker..."

    yes | sudo pacman -S docker
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
    sudo usermod -aG docker $USER
    newgrp docker
}

install_sysbox() {
    log_task "Installing sysbox-runc from AUR..."

    yes | yay -S --answerclean All --answerdiff All --answeredit All --answerupgrade Repo sysbox-ce-bin
    
    sudo systemctl enable sysbox.service
    sudo systemctl start sysbox.service

    mkdir -p /etc/docker
    
    echo '{ 
  "runtimes": { 
    "sysbox-runc": { 
      "path": "/usr/bin/sysbox-runc" 
    } 
  } 
}' | sudo tee /etc/docker/daemon.json > /dev/null

    sudo systemctl restart docker.service
    # to uninstall, see: https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install-package.md#uninstallation
}

install_eza() {
    log_blue "Installing eza..."
    yes | sudo pacman -S eza
}

install_tobgrade() {
    log_blue "Installing topgrade from AUR..."
    yes | yay -S --answerclean All --answerdiff All --answeredit All --answerupgrade Repo topgrade-bin
}

install_lazygit() {
    log_blue "Installing lazygit..."
    yes | sudo pacman -S lazygit
}

install_zoxide() {
    log_blue "Installing zoxide..."
    yes | sudo pacman -S zoxide

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

