-- Fuzzy Finder (files, lsp, etc)

-- UNCOMMENT BELOW TO USE FILE NAME FIRST PATH DISPLAY
-- See: https://github.com/nvim-telescope/telescope.nvim/issues/2014#issuecomment-1873229658
--
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'TelescopeResults',
--   callback = function(ctx)
--     vim.api.nvim_buf_call(ctx.buf, function()
--       vim.fn.matchadd('TelescopeParent', '\t\t.*$')
--       vim.api.nvim_set_hl(0, 'TelescopeParent', { link = 'Comment' })
--     end)
--   end,
-- })
--
-- local function filenameFirst(_, path)
--   local tail = vim.fs.basename(path)
--   local parent = vim.fs.dirname(path)
--   if parent == '.' then
--     return tail
--   end
--   return string.format('%s\t\t%s', tail, parent)
-- end

return {
  'nvim-telescope/telescope.nvim',

  branch = '0.1.x',

  dependencie = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },

  config = function()
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      defaults = {
        layout_strategy = 'vertical',
        layout_config = {
          vertical = {
            width = 0.95,
          },
          horizontal = {
            width = 0.90,
          },
        },
        path_display = { 'truncate' },
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          -- path_display = filenameFirst,
        },
        buffers = {
          mappings = {
            n = {
              -- Deletes the selected buffer
              ['d'] = {
                require('telescope.actions').delete_buffer,
                type = 'action',
              },
            },
          },
        },
      },
    }

    -- [[ Configure Indent Blankline ]]
    require('ibl').setup()

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')

    -- See `:help telescope.builtin`
    vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = 'Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = 'Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
    vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
  end,
}
