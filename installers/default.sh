#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu
source ./helper.sh

install_pacapt() {
    sudo wget -O /usr/local/bin/pacapt https://github.com/icy/pacapt/raw/ng/pacapt
    sudo chmod 755 /usr/local/bin/pacapt
    sudo ln -sv /usr/local/bin/pacapt /usr/local/bin/pacman || true
}

install_nvim() {
    log_task "Installing NEOVIM..."
    curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o nvim.tar.gz
    sudo rm -rf /opt/nvim
    sudo mkdir /opt/nvim
    sudo tar -xzvf nvim.tar.gz -C /opt/nvim --strip-components=1
    rm -rf nvim.tar.gz
}

# Deprecated, using prezto for better performance
install_oh_my_zsh() {
    log_task "Installing oh-my-zsh..."
    log_manual_action "oh-my-zsh is deprecated, suggesting using prezto instead for better performance. To install, try install_prezto"
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

# install prezto if not exist, otherwise, update it
install_prezto() {
    log_task "Installing prezto..."

    if ! command -v zsh 2>&1 >/dev/null; then
        log_red "zsh is not installed, skip installing prezto"
        return 0
    fi

    if [ ! -d ${ZDOTDIR:-$HOME}/.zprezto ]; then
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
        
    zsh -c "$(cat << 'EOF'
        setopt EXTENDED_GLOB
        for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^(README.md|zshrc|zpreztorc)(.N); do
          ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
        done 
EOF
    )"

        git clone https://github.com/Aloxaf/fzf-tab ${ZDOTDIR:-$HOME}/.zprezto/contrib/fzf-tab
        chsh -s /bin/zsh
    else
        log_blue "prezto detected, check for update..."   
        cd ${ZDOTDIR:-$HOME}/.zprezto
        git pull
        git submodule sync --recursive
        git submodule update --init --recursive

        # update all plugins under folder contrib
        for repo in ${ZDOTDIR:-$HOME}/.zprezto/contrib/*; do
            # check if it's a directory and contains a .git subdirectory
            if [ -d "$repo" ] && [ -d "$repo/.git" ]; then
                echo "updating $repo..."
                (cd "$repo" && git pull)
                if [ ! $? -eq 0 ]; then
                    echo "Failed to update $repo"
                fi
            fi
        done
    fi
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

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

    source "$HOME/.cargo/env" 
    # rust toolchain auto completions
    echo 'eval "$(rustup completions zsh rustup)"' >> ~/.local.sh
    echo 'eval "$(rustup completions zsh cargo )"' >> ~/.local.sh
}

