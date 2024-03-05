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

    log_blue "Checking updates..."
    sudo apt update

    log_blue "Installing..."
    sudo apt install btop zsh ripgrep fd-find curl wget git tmux bat fzf unzip

    sudo ln -sfnv /usr/bin/fdfind /usr/bin/fd
    sudo ln -sfnv /usr/bin/batcat /usr/bin/bat
}

install_nvim() {
    log_blue "Installing neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm -rf nvim-linux64.tar.gz
}

install_oh_my_zsh() {
    log_blue "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    log_blue "Installing zsh plugins..."
    gh="https://github.com/"
    omz="$HOME/.oh-my-zsh/custom"
    omz_plugin="$omz/plugins/"

    # git clone "$gh/marlonrichert/zsh-autocomplete" "$omz_plugin/zsh-autocomplete"
    # git clone "$gh/clarketm/zsh-completions" "$omz_plugin/zsh-completions"
    git clone "$gh/Aloxaf/fzf-tab" "$omz_plugin/fzf-tab"
    git clone "$gh/zsh-users/zsh-autosuggestions" "$omz_plugin/zsh-autosuggestions"
    git clone "$gh/zdharma-continuum/fast-syntax-highlighting" "$omz_plugin/fast-syntax-highlighting"
    # git clone "$gh/djui/alias-tips" "$omz_plugin/alias-tips"
    git clone "$gh/unixorn/git-extra-commands" "$omz_plugin/git-extra-commands" # https://github.com/unixorn/git-extra-commands
    git clone "$gh/hlissner/zsh-autopair" "$omz_plugin/zsh-autopair"

    chsh -s "$(which zsh)"
}

setup_ssh() {
    log_blue "Setup SSH key for you..."
  # TODO: ssh setup
  # TODO: git-delta setup
}

install_git_delta() {
    log_blue "Installing git-delta..."
    url="https://github.com/dandavison/delta/releases/download/0.16.5/git-delta-musl_0.16.5_amd64.deb"
    name="git-delta-for-setup"

    rm -rf "./$name"
    curl -fsSL "$url" -o "$name"
    sudo dpkg -i "$name"
    rm -rf "./$name"
}

all() {
    install_essentials
    install_nvim
    install_oh_my_zsh
    install_git_delta
    setup_ssh
}

"$@"
