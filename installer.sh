#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu
source ./helper.sh

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
    sudo apt-get install -y btop zsh ripgrep fd-find curl wget git tmux bat fzf unzip vim

    sudo ln -sfnv /usr/bin/fdfind /usr/bin/fd
    sudo ln -sfnv /usr/bin/batcat /usr/bin/bat
}

install_nvim() {
    log_task "Installing neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim-linux64
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm -rf nvim-linux64.tar.gz
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

    url="https://go.dev/dl/go1.22.0.linux-amd64.tar.gz"
    name="golang.tar.gz"

    rm -rf "./$name"
    curl -fSL "$url" -o "$name"
    rm -rf /usr/local/go && tar -C /usr/local -xzf "$name"
    rm -rf "./$name"

    export PATH=$PATH:/usr/local/go/bin

    go version
}

install_rust() {
    log_task "Installing rust lang..."

    zsh="$HOME/.oh-my-zsh"

    sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)" "" -y
    mkdir -p "$zsh/completions/"

    source "$HOME/.cargo/env" 
    rustup completions zsh rustup> "$zsh/completions/_rustup"
    rustup completions zsh cargo > "$zsh/completions/_cargo"

    echo source '$HOME'/.cargo/env >> "$HOME/.local.sh"
}


install_python3() {
    sudo apt-get install -y python3
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

install_extras() {
    log_task "Installing extra package..."
    check_lang_installed

    cargo install eza
    cargo install topgrade 
    go install github.com/jesseduffield/lazygit@latest
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

