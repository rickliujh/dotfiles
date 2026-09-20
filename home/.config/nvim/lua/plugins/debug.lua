-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    local util = require 'dapui.util'
    local function is_active()
      local b = not not dap.session()
      if not b then
        util.notify('No active debug session', vim.log.levels.WARN)
      end
      return b
    end
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { '<F5>', dap.continue, desc = 'Start/Continue' },
      { '<F6>', dap.step_into, desc = 'Step Into' },
      { '<F7>', dap.step_over, desc = 'Step Over' },
      { '<F8>', dap.step_out, desc = 'Step Out' },
      { '<leader>db', dap.toggle_breakpoint, desc = 'Toggle Breakpoint' },
      {
        '<leader>dc',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Set Condition Breakpoint',
      },
      {
        '<leader>dl',
        function()
          dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
        end,
        desc = 'Set Log Point',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { '<leader>dt', dapui.toggle, desc = 'See last session result.' },
      {
        '<leader>de',
        function()
          if not is_active() then
            return
          end
          dapui.eval(nil, { enter = true })
        end,
        desc = 'Eval variable',
      },
      {
        '<leader>df',
        function()
          if not is_active() then
            return
          end
          dapui.float_element(nil, { enter = true })
        end,
        desc = 'Open a debugger component',
      },
      -- { '<leader>k', dapui.eval, desc = 'Debug: eval variable' },
      unpack(keys),
    }
  end,
  config = function()
    -- coloring breakpoints
    local function set_dap_color()
      vim.api.nvim_set_hl(0, 'DapBreakPointRed', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
      vim.api.nvim_set_hl(0, 'DapBreakPointBlue', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
      vim.api.nvim_set_hl(0, 'DapBreakPointGreen', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })
    end
    vim.api.nvim_create_augroup('DapCustomColors', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      group = 'DapCustomColors',
      desc = 'prevent colorscheme clears self-defined DAP icon colors.',
      callback = set_dap_color,
    })
    set_dap_color()

    vim.fn.sign_define('DapBreakpoint', { text = '󰄯', texthl = 'DapBreakPointRed', linehl = '', numhl = 'DapBreakPointRed' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '󰟃', texthl = 'DapBreakPointRed', linehl = '', numhl = 'DapBreakPointRed' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapBreakPointBlue', linehl = '', numhl = 'DapBreakPointBlue' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapBreakPointGreen', linehl = '', numhl = 'DapBreakPointGreen' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = '', linehl = '', numhl = '' })

    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      -- icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      -- controls = {
      --   icons = {
      --     pause = '⏸',
      --     play = '▶',
      --     step_into = '⏎',
      --     step_over = '⏭',
      --     step_out = '⏮',
      --     step_back = 'b',
      --     run_last = '▶▶',
      --     terminate = '⏹',
      --     disconnect = '⏏',
      --   },
      -- },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
