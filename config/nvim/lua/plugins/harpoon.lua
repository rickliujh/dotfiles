return {
  'ThePrimeagen/harpoon',

  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  config = function()
    -- [[ Configure Harpoon]]
    -- Basic setup to helps to switch between buffers.
    vim.keymap.set('n', '<C-e>', require('harpoon.ui').toggle_quick_menu)
    vim.keymap.set('n', '<leader>ha', require('harpoon.mark').add_file, { desc = 'add file on harpoon' })
    vim.keymap.set('n', '<leader>hd', require('harpoon.mark').rm_file, { desc = 'delete file from harpoon' })
    vim.keymap.set('n', '<leader>hc', require('harpoon.mark').clear_all, { desc = 'claer all file on harpoon' })
    vim.keymap.set('n', '<M-9>', require('harpoon.ui').nav_next)
    vim.keymap.set('n', '<M-0>', require('harpoon.ui').nav_prev)
    vim.keymap.set('n', '<M-1>', function() require('harpoon.ui').nav_file(1) end)
    vim.keymap.set('n', '<M-2>', function() require('harpoon.ui').nav_file(2) end)
    vim.keymap.set('n', '<M-3>', function() require('harpoon.ui').nav_file(3) end)
  end
}
