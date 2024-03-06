colorscheme desert

" Set leader key
let mapleader = " "
let maplocalleader = ' '

" Disable highlight search and enable incremental search
set nohlsearch
set incsearch

" Make line numbers default
set number

" Enable mouse mode
set mouse=a
set cursorline
set cursorlineopt=number
set relativenumber

" Enable break indent
set breakindent

" Save undo history
set undofile

" Case-insensitive searching UNLESS \C or capital in search
set ignorecase
set smartcase

" Keep signcolumn on by default
set signcolumn=yes

" Decrease update time
set updatetime=250
set timeoutlen=300

" Set completeopt to have a better completion experience
set completeopt=menuone,noselect

" NOTE: You should make sure your terminal supports this
set termguicolors

" Set undotree file directory
set undodir=~/.local/state/vi/undodir
set undofile

" Set scrolloff
set scrolloff=8

" Set colorcolumn
set colorcolumn=85

" Basic Keymaps

" Keymaps for better default experience
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>

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
nnoremap <Leader>a ggVG

" Paste but still keeping the it
xnoremap <leader>p "_dP

" Yank to '+' register (system clipboard)
noremap <leader>y "+y
noremap <leader>Y "+Y

" Delete without add it to clipboard aka black hole register, register '_'
noremap <leader>d "_d

" Avoid using quicksearch
nnoremap Q <nop>

" Using tmux to quick switch between projects
nnoremap <C-f> :silent !tmux neww tmux-sessionizer<CR>

" Quickfix navigation
nnoremap <C-k> :cnext<CR>zz
nnoremap <C-j> :cprev<CR>zz
nnoremap <leader>k :lnext<CR>zz
nnoremap <leader>j :lprev<CR>zz

" Replace the word in current cursor
nnoremap <leader>sr :%s/\\<<C-r><C-w>\\>/\\<<C-r><C-w>\\>/gI<Left><Left><Left>

" Make current file executable
nnoremap <leader>x :!chmod +x %<CR>

" Ctrl-j/k deletes blank line below/above, and Alt-j/k inserts.
" nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
" nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
" nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
" nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
