-- neovim session management
return {
  'echasnovski/mini.sessions',
  version = '*',
  opts = {
    -- Whether to read latest session if Neovim opened without file arguments
    autoread = true,

    -- Whether to write current session before quitting Neovim
    autowrite = true,

    -- Directory where global sessions are stored (use `''` to disable)
    directory = '', --<"session" subdir of user data directory from |stdpath()|>,

    -- File for local session (use `''` to disable)
    file = 'Session.vim',

    -- Whether to force possibly harmful actions (meaning depends on function)
    force = { read = false, write = true, delete = false },

    -- Hook functions for actions. Default `nil` means 'do nothing'.
    hooks = {
      -- Before successful action
      pre = { read = nil, write = nil, delete = nil },
      -- After successful action
      post = { read = nil, write = nil, delete = nil },
    },

    -- Whether to print session path after action
    verbose = { read = false, write = true, delete = true },
  },
  config = function(_, opts)
    local s = require('mini.sessions')
    s.setup(opts)

    local perpareFile = function(_opts)
      local path = _opts.args
      if path ~= '' and vim.fn.isdirectory(path) ~= 1 then
        error('Invalid directory')
      end
      return path == '' and nil or vim.fn.fnamemodify(path, ':p') .. opts.file
    end

    vim.api.nvim_create_user_command(
      'SessionWrite',
      function(opts)
        s.write(perpareFile(opts))
      end,
      { nargs = '?', complete = 'dir', desc = "Create or write a local session" }
    )

    vim.api.nvim_create_user_command(
      'SessionList',
      function()
        s.select()
      end,
      { desc = "List sessions" }
    )

    vim.api.nvim_create_user_command(
      'SessionDelete',
      function(opts)
        s.delete(perpareFile(opts))
      end,
      { nargs = '?', complete = 'dir', desc = "Delete session" }
    )

    vim.api.nvim_create_user_command(
      'SessionRead',
      function()
        s.read(perpareFile(opts))
      end,
      { nargs = '?', complete = 'dir', desc = "Load session" }
    )
  end
}
