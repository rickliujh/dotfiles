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
    enabled = true,
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
      views = {
        split = {
          backend = 'split',
          enter = true,
        },
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      {
        'rcarriga/nvim-notify',
        config = function()
          local stages_util = require 'notify.stages.util'
          local direction = stages_util.DIRECTION.BOTTOM_UP
          require('notify').setup {
            fps = 1,
            background_colour = '#000000',
            render = 'minimal',
            -- no_animation
            -- https://github.com/rcarriga/nvim-notify/tree/master?tab=readme-ov-file#animation-style
            -- https://github.com/rcarriga/nvim-notify/blob/master/lua/notify/stages/no_animation.lua
            stages = {
              function(state)
                local next_height = state.message.height + 2
                local next_row = stages_util.available_slot(state.open_windows, next_height, direction)
                if not next_row then
                  return nil
                end
                return {
                  relative = 'editor',
                  anchor = 'NE',
                  width = state.message.width,
                  height = state.message.height,
                  col = vim.opt.columns:get(),
                  row = next_row,
                  border = 'none',
                  style = 'minimal',
                }
              end,
              function(state, win)
                return {
                  col = vim.opt.columns:get(),
                  time = true,
                  row = stages_util.slot_after_previous(win, state.open_windows, direction),
                }
              end,
            },
            timeout = 2800,
            top_down = false,
          }
        end,
      },
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
