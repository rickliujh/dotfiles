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

  log_blur "installing..."
  sudo apt install btop zsh ripgrep lazygit fd-find curl wget git tmux bat fzf eza unzip

  sudo ln -sfnv /usr/bin/fdfind /usr/bin/fd
  sudo ln -sfnv /usr/bin/batcat /usr/bin/bat
}

install_nvim() {
  log_blur "installing neovim..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
}
