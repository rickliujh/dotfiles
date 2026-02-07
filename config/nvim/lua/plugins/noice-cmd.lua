--[[
  Usage
    :Noice or :Noice history shows the message history
    :Noice last shows the last message in a popup
    :Noice dismiss dismiss all visible messages
    :Noice errors shows the error messages in a split. Last errors on top
    :Noice disable disables Noice
    :Noice enable enables Noice
    :Noice stats shows debugging stats
    :Noice telescope opens message history in Telescope
--]]
return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = false, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      routes = {
        {
          -- https://github.com/folke/noice.nvim/issues/1097
          filter = { event = 'msg_show', kind = { 'shell_out', 'shell_err' } },
          view = 'split',
          opts = {
            level = 'info',
            skip = false,
            replace = false,
          },
        },
      },
      notify = {
        enabled = false,
        view = 'notify',
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- {
      --   'rcarriga/nvim-notify',
      --   opts = {
      --     background_colour = '#000000',
      --     render = 'wrapped-compact',
      --     stages = 'static',
      --   },
      -- },
    },
    config = function(_, opts)
      local noice = require 'noice'

      noice.setup(opts)

      vim.keymap.set('n', '<leader>nc', function()
        noice.cmd 'dismiss'
      end, { desc = 'Noice: dismiss all visible messages' })

      vim.keymap.set('n', '<leader>nh', function()
        noice.cmd 'pick'
      end, { desc = 'Noice: browse notification history' })
    end,
  },
}
