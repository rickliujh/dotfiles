local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- import/override with your plugins
    { import =  "plugins" },
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true },
  -- border for lazy
  ui = {
    border = "rounded",
  }
})

