" Config for Obsidian specifically

unmap <Space>

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back
exmap forward obcommand app:go-forward
nmap <C-i> :forward

" Surrounds
exmap surround_wiki surround [[ ]]
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backticks surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }

" NOTE: must use 'map' and not 'nmap'
map [[ :surround_wiki
nunmap s
vunmap s
map s" :surround_double_quotes
map s' :surround_single_quotes
map s` :surround_backticks
map sb :surround_brackets
map s( :surround_brackets
map s) :surround_brackets
map s[ :surround_square_brackets
map s[ :surround_square_brackets
map s{ :surround_curly_brackets
map s} :surround_curly_brackets

" Editor Format
exmap bold obcommand editor:toggle-bold
exmap italics obcommand editor:toggle-italics
exmap strikethrough obcommand editor:toggle-strikethrough
exmap highlight obcommand editor:toggle-highlight
exmap switcher obcommand switcher:open
exmap livegrep obcommand global-search:open
exmap quote obcommand editor:toggle-blockquote
exmap comment obcommand editor:toggle-comments
exmap clearfmt obcommand editor:clear-formatting
exmap fileexplorer obcommand file-explorer:open
exmap togglefold obcommand editor:toggle-fold
exmap unfoldall obcommand editor:unfold-all
exmap foldall obcommand editor:fold-all
exmap split obcommand workspace:split-horizontal
exmap splitv obcommand workspace:split-vertical
exmap gotop obcommand editor:focus-top
exmap gobottom obcommand editor:focus-bottom
exmap goleft obcommand editor:focus-left
exmap goright obcommand editor:focus-right
exmap leftbar obcommand app:toggle-left-sidebar
exmap rightbar obcommand app:toggle-right-sidebar
exmap cmenu obcommand editor:context-menu
exmap backlink obcommand backlink:open

noremap <Space>fb :bold
noremap <Space>fi :italics
noremap <Space>ft :strikethrough
noremap <Space>fh :highlight
noremap <Space>fq :quote
noremap gcc :comment
noremap <Space>fc :clearfmt
nmap <Space>sf :switcher
nmap <Space>sg :livegrep
nmap zo :togglefold
nmap zc :togglefold
nmap za :togglefold
nmap zR :unfoldall
nmap zM :foldall
nmap <C-w>s :split
nmap <C-w>v :splitv
nmap <C-k> :gotop
nmap <C-j> :gobottom
nmap <C-h> :goleft
nmap <C-l> :goright
nmap <Space>[ :leftbar
nmap <Space>] :rightbar
nmap z= :cmenu
nmap <Space>gb :backlink

" Some Commands
exmap q obcommand workspace:close
exmap Ex obcommand file-explorer:open

" For everything else, use a tab width of 4 space chars.
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

" Basic Keymaps

" Remap for dealing with word wrap
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Moving things selected around in v mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Append next line to this line recursively
nnoremap J mzJ`z

" Keep cursor in the center when you moving around
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Select all shortcut
nnoremap <Space>a ggVG

" Yank to '+' register (system clipboard)
noremap <Space>y "+y
noremap <Space>Y "+Y

" Delete without add it to clipboard aka black hole register, register '_'
noremap <Space>d "_d

" Avoid using quicksearch
nnoremap Q <nop>

" Using tmux to quick switch between projects
nnoremap <C-f> :silent !tmux neww tmux-sessionizer<CR>

" Quickfix navigation
" nnoremap <C-k> :cnext<CR>zz
" nnoremap <C-j> :cprev<CR>zz
nnoremap <Space>k :lnext<CR>zz
nnoremap <Space>j :lprev<CR>zz

" Replace the word in current cursor
nnoremap <Space>sr :%s/\\<<C-r><C-w>\\>/\\<<C-r><C-w>\\>/gI<Left><Left><Left>

" Make current file executable
nnoremap <Space>x :!chmod +x %<CR>

" Ctrl-j/k deletes blank line below/above, and Alt-j/k inserts.
" nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
" nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
" nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
" nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

