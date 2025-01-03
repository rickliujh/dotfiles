vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Highlight the line number.
vim.o.cursorline = true
-- vim.o.cursorlineopt = 'number'
vim.o.relativenumber = true

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Set undotree file
vim.o.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.o.undofile = true

vim.o.scrolloff = 8

vim.o.colorcolumn = "85"

-- A TAB character looks like 4 spaces
vim.o.tabstop = 4
-- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.expandtab = true
-- Number of spaces inserted instead of a TAB character
vim.o.softtabstop = 4
-- Number of spaces inserted when indenting
vim.o.shiftwidth = 4

-- enable spell check
vim.o.spell = true
vim.o.spelllang = "en_us"

-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'
