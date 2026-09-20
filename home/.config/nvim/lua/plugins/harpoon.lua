return {
  'ThePrimeagen/harpoon',

  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  config = function()
    -- [[ Configure Harpoon]]
    -- Basic setup to helps to switch between buffers.
    local ui = require('harpoon.ui')
    local mark = require('harpoon.mark')
    vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu, { desc = 'Harpoon: open explorer' })
    vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = 'Harpoon: add buf' })
    vim.keymap.set('n', '<leader>hd', mark.rm_file, { desc = 'Harpoon: delete buf' })
    vim.keymap.set('n', '<leader>hc', mark.clear_all, { desc = 'Harpoon: claer all buf' })
    vim.keymap.set('n', '<M-j>', ui.nav_next, { desc = 'Harpoon: next buf' })
    vim.keymap.set('n', '<M-k>', ui.nav_prev, { desc = 'Harpoon: previous buf' })
    vim.keymap.set('n', '<M-1>', function() ui.nav_file(1) end, { desc = 'Harpoon: buf slot 0' })
    vim.keymap.set('n', '<M-2>', function() ui.nav_file(2) end, { desc = 'Harpoon: buf slot 1' })
    vim.keymap.set('n', '<M-3>', function() ui.nav_file(3) end, { desc = 'Harpoon: buf slot 2' })
  end
}
