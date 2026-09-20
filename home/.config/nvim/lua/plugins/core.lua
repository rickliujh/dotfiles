return {
  -- Git related plugins
  -- {
  --   'tpope/vim-fugitive',
  --   config = function()
  --     vim.api.nvim_create_user_command('Glg', ":G log --graph --pretty=format:'%h -%d %s (%cr) <%an>' --abbrev-commit <args>", { nargs = '*', desc = '' })
  --   end,
  -- },
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Undo tree
  'mbbill/undotree',

  -- Making code rain
  'eandrju/cellular-automaton.nvim',

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk_inline<CR>', { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  {
    'sindrets/diffview.nvim',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- init = function()
    --   vim.keymap.set('n', '<leader>gd', ':DiffviewOpen<CR>', { desc = 'Start a 4-way merge diff view' })
    -- end,
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', ':DiffviewOpen<CR>', desc = 'Start a 4-way merge diff view' },
    },
    opts = {
      view = {
        -- Config for conflicted files in diff views during a merge or rebase.
        merge_tool = {
          layout = 'diff4_mixed',
          disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
          winbar_info = true, -- See |diffview-config-view.x.winbar_info|
        },
      },
    },
  },

  {
    'NeogitOrg/neogit',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Neogit',
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' },
    },
    init = function(neogit)
      vim.api.nvim_create_user_command(
        'G', -- The new command name (must start with an uppercase letter)
        ':Neogit <args>', -- The command it runs
        { nargs = '*', bang = true } -- Allows the use of ! with the command (e.g., :Ng!)
      )
    end,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
}
