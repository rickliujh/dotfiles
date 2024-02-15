#!/bin/sh
echo "Start setup system..."

echo "Checking updates..."
sudo apt update

echo "btop is the better top for linux"
sudo apt install btop

echo "installing zsh"
sudo apt install zsh

echo "install nvim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

export PATH="$PATH:/opt/nvim-linux64/bin"


