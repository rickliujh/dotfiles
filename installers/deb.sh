#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu

log_task "loading deb.sh"

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
    sudo apt-get update

    log_task "Installing..."
    sudo apt-get install -y btop zsh ripgrep fd-find curl wget git tmux bat fzf unzip vim lsof tree

    sudo ln -sfnv /usr/bin/fdfind /usr/bin/fd
    sudo ln -sfnv /usr/bin/batcat /usr/bin/bat
}

install_python3() {
    sudo apt-get install -y python3
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # for uv auto completions call f_eval_comp
}

install_node() {
    # https://github.com/nodesource/distribution
    version="22"
    # Download and install fnm:
    curl -o- https://fnm.vercel.app/install | bash
    # Download and install Node.js:
    fnm install $version
    # Verify the Node.js version:
    node -v # Should print "v22.14.0".
    # Download and install Yarn:
    corepack enable yarn
    # Verify Yarn version:
    yarn -v
}

install_dev_pkgs() {
    sudo apt-get install -y build-essential
}

install_docker() {
    if ! command -v docker 2>&1 >/dev/null
    then
        log "uninstall conflicting packages..."
        for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
        
        log "setting up Docker's apt repository..."
        # Add Docker's official GPG key:
        sudo apt-get update
        sudo apt-get install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        # Add the repository to Apt sources:
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
          $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update

        log "install the latest version..."
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    fi
}

install_sysbox() {
    rm -rf ./sysbox-ce.deb
    version="https://downloads.nestybox.com/sysbox/releases/v0.6.6/sysbox-ce_0.6.6-0.linux_amd64.deb"
    curl -L $version -o sysbox-ce.deb
    docker rm $(docker ps -a -q) -f || true
    sudo apt-get install jq
    sudo apt-get install ./sysbox-ce.deb
    rm -rf ./sysbox-ce.deb

    # to uninstall, see: https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install-package.md#uninstallation
}

install_eza() {
    log_blue "Installing eza, rust lang is required..."
    cargo install eza
}

install_tobgrade() {
    log_blue "Installing topgrade, rust lang is required..."
    cargo install topgrade 
}

install_lazygit() {
    log_blue "Installing lazygit, golang is required..."
    go install github.com/jesseduffield/lazygit@latest
}

install_zoxide() {
    log_blue "Installing zoxide..."
    cargo install zoxide --locked

    if [ ! -f "~/.local_sh" ]; then
        touch ~/.local.sh
    fi
    echo '
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
else
  return 1
fi' >> ~/.local.sh
}

