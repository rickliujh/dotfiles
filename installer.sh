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

  log_blue "Checking updates..."
  sudo apt update

  log_blur "Installing..."
  sudo apt install btop zsh ripgrep lazygit fd-find curl wget git tmux bat fzf eza unzip

  sudo ln -sfnv /usr/bin/fdfind /usr/bin/fd
  sudo ln -sfnv /usr/bin/batcat /usr/bin/bat
}

install_nvim() {
  log_blur "Installing neovim..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
}

install_oh_my_zsh() {
    log_blur "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    log_blur "Installing zsh plugins..."
    gh="https://github.com/"
    omz="$HOME/.oh-my-zsh/custom"
    omz_plugin="$omz/plugins/"

    # git clone "$gh/marlonrichert/zsh-autocomplete" "$omz_plugin/zsh-autocomplete"
    # git clone "$gh/clarketm/zsh-completions" "$omz_plugin/zsh-completions"
    git clone "$gh/Aloxaf/fzf-tab" "$omz_plugin/fzf-tab"
    git clone "$gh/zsh-users/zsh-autosuggestions" "$omz_plugin/zsh-autosuggestions"
    git clone "$gh/z-shell/F-Sy-H" "$omz_plugin/F-Sy-H"
    git clone "$gh/djui/alias-tips" "$omz_plugin/alias-tips"
    git clone "$gh/unixorn/git-extra-commands" "$omz_plugin/git-extra-commands" # https://github.com/unixorn/git-extra-commands
    git clone "$gh/hlissner/zsh-autopair" "$omz_plugin/zsh-autopair"

    chsh -s "$(which zsh)"
}
