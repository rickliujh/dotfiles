#!/bin/sh

export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:/opt/nvim/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.cargo/bin

# fix ssh error: Unsuitable Terminal xterm-ghostty
# https://vninja.net/2024/12/28/ghostty-workaround-for-missing-or-unsuitable-terminal-xterm-ghostty/
if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export TERM=xterm-256color
fi
