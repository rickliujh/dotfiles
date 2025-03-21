# See: https://github.com/junegunn/fzf/tree/master
# See: https://mike.place/2017/fzf-fd/

source <(fzf --zsh)

export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_DEFAULT_OPTS="
    --layout=reverse 
    --inline-info"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-\:change-preview-window(down|hidden|)'
  --header 'Press CTRL-\ to change preview window'"

export FZF_ALT_C_COMMAND="fd -t d . $HOME"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
