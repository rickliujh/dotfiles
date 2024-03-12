# dotfiles
Linux and desktop configuration and setup script.

## Installation

### Download
`git clone git@github.com:rickliujh/dotfiles.git`

### Usage
1. `bash setup.sh -m` show menu.
2. `bash setup.sh -a` setup all things.
3. `bash setup.sh -i` install all packages and languages.
4. `bash setup.sh -l` setup symlinks only.
5. `bash setup.sh -b` backup current dotfiles (only those files that has same name in config dir in this repo).
6. `bash setup.sh {{func_name}}` you can actually call any function that declared in shell file in root folder by putting its name after setup.sh separated by space as long as you know what you're doing.

## Next...
1. understanding fzf and its config 
2. ~~understanding bashrc~~
3. understanding zshrc with oh-my-zsh 
4. ~~setting up tmux~~
5. understanding eza and its config and how to integrating with zsh(require 3)

## Inspired by
- [2KAbhishek/dots2k: Passionately crafted for CLI lovers (github.com)](https://github.com/2KAbhishek/dots2k)
- [felipecrs/dotfiles: Bootstrap your Ubuntu in a single command! (github.com)](https://github.com/felipecrs/dotfiles)

