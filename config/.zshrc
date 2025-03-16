if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

setopt ignore_eof

fpath=(/usr/share/zsh/vendor-completions $fpath)

# fzf keybindings
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Common environment variables
[ -f ~/.config/shell/envars.sh ] && source ~/.config/shell/envars.sh

# Common functions
[ -f ~/.config/shell/functions.sh ] && source ~/.config/shell/functions.sh

# Common aliases
[ -f ~/.config/shell/aliases.sh ] && source ~/.config/shell/aliases.sh

# Local configurations
[ -f ~/.local.sh ] && source ~/.local.sh

# Key Binding
bindkey '^.' autosuggest-fetch

