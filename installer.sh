#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu
source ./helper.sh

ZSH_COMPLETION_PATH="$HOME/.oh-my-zsh/completions"

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
    sudo apt-get install -y btop zsh ripgrep fd-find curl wget git tmux bat fzf unzip vim lsof

    sudo ln -sfnv /usr/bin/fdfind /usr/bin/fd
    sudo ln -sfnv /usr/bin/batcat /usr/bin/bat
}

install_nvim() {
    log_task "Installing NEOVIM..."
    curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o nvim.tar.gz
    sudo rm -rf /opt/nvim
    sudo mkdir /opt/nvim
    sudo tar -xzvf nvim.tar.gz -C /opt/nvim --strip-components=1
    rm -rf nvim.tar.gz
}

install_oh_my_zsh() {
    log_task "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    log_task "Installing zsh plugins..."
    gh="https://github.com/"
    omz="$HOME/.oh-my-zsh/custom"
    omz_plugin="$omz/plugins/"

    # git clone "$gh/marlonrichert/zsh-autocomplete" "$omz_plugin/zsh-autocomplete"
    # git clone "$gh/clarketm/zsh-completions" "$omz_plugin/zsh-completions"
    git clone "$gh/Aloxaf/fzf-tab" "$omz_plugin/fzf-tab"
    git clone "$gh/zsh-users/zsh-autosuggestions" "$omz_plugin/zsh-autosuggestions"
    git clone "$gh/zdharma-continuum/fast-syntax-highlighting" "$omz_plugin/fast-syntax-highlighting"
    git clone "$gh/djui/alias-tips" "$omz_plugin/alias-tips"
    git clone "$gh/unixorn/git-extra-commands" "$omz_plugin/git-extra-commands" # https://github.com/unixorn/git-extra-commands
    git clone "$gh/hlissner/zsh-autopair" "$omz_plugin/zsh-autopair"

    chsh -s "$(which zsh)"
}

install_tmux_plugin() {
    # https://github.com/tmux-plugins/tpm
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
}

install_git_delta() {
    log_task "Installing git-delta..."
    url="https://github.com/dandavison/delta/releases/download/0.16.5/git-delta-musl_0.16.5_amd64.deb"
    name="git-delta-for-setup"

    rm -rf "./$name"
    curl -fsSL "$url" -o "$name"
    sudo dpkg -i "$name"
    rm -rf "./$name"
}

install_go() {
    log_task "Installing golang..."

    latest=$(curl "https://go.dev/VERSION?m=text" | head -n 1)
    url="https://go.dev/dl/$latest.linux-amd64.tar.gz"
    name="golang.tar.gz"

    rm -rf "./$name"
    curl -fSL "$url" -o "$name"
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "$name"
    rm -rf "./$name"

    export PATH=$PATH:/usr/local/go/bin

    go version
}

install_rust() {
    log_task "Installing rust lang..."
    mkdir -p $ZSH_COMPLETION_PATH

    sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)" --no-modify-path -y

    source "$HOME/.cargo/env" 
    rustup completions zsh rustup> "$ZSH_COMPLETION_PATH/_rustup"
    rustup completions zsh cargo > "$ZSH_COMPLETION_PATH/_cargo"
    # echo source '$HOME'/.cargo/env >> "$HOME/.local.sh"
}


install_python3() {
    sudo apt-get install -y python3
    curl -LsSf https://astral.sh/uv/install.sh | sh
}

install_node() {
    # https://github.com/nodesource/distribution
    version="setup_lts.x"
    rm -rf $version
    curl -fsSL "https://deb.nodesource.com/$version" | sudo -E bash - && sudo apt-get install -y nodejs
    rm -rf $version
    sudo corepack enable
}

install_dev_pkgs() {
    sudo apt-get install -y build-essential
}

install_docker() {
    if ! command -v docker 2>&1 >/dev/null
    then
        echo "uninstall conflicting packages..."
        for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
        
        echo "setting up Docker's apt repository..."
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

        echo "install the latest version..."
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

