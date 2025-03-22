setopt ignore_eof

# Key Binding
bindkey '^.' autosuggest-fetch

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

fpath=(/usr/share/zsh/vendor-completions $fpath)

# fzf keybindings
[ -f ~/.fzf.sh ] && source ~/.fzf.sh

# Common functions
[ -f ~/.config/shell/functions.sh ] && source ~/.config/shell/functions.sh

# Common aliases
[ -f ~/.config/shell/aliases.sh ] && source ~/.config/shell/aliases.sh

# Local configurations
[ -f ~/.local.sh ] && source ~/.local.sh
