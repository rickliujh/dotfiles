return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    config = function()
      local theme = require('lualine.themes.iceberg_dark')

      -- Transparent background
      for k in pairs(theme) do
        if theme[k].c then
          theme[k].c.bg = 'None'
        else
          theme[k].c = { bg = 'None' }
        end
      end

      require('lualine').setup {
        options = {
          theme = theme,
          icons_enabled = false,
          component_separators = '|',
          section_separators = '',
        }
      }
    end
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function(_, opts)
      require('onedark').setup(opts)
      vim.cmd.colorscheme 'onedark'
    end,
    opts = {
      style = 'cool',
    },
    enabled = false,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      extend_background_behind_borders = true,
      styles = { transparency = true },
      highlight_groups = {
        -- see: https://neovim.io/doc/user/syntax.html#hl-Pmenu
        Pmenu = { bg = '#393552' },
        NormalFloat = { bg = '#393552' },
        PmenuSel = { bg = 'pine' },
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)

      vim.cmd.colorscheme 'rose-pine-main'
    end,
    enabled = true,
  },

  {
    'comfysage/evergarden',
    config = function(_, opts)
      require('evergarden').setup(opts)
      vim.cmd.colorscheme 'evergarden'
    end,
    opts = {
      transparent_background = true,
      override_terminal = true,
      contrast_dark = 'medium', -- 'hard'|'medium'|'soft'
      style = {
        comment = { italic = true },
      },
      overrides = {
        SpellBad = { default = true, undercurl = true, },
        SpellCap = { default = true, undercurl = true, },
        SpellLocal = { default = true, undercurl = true, },
        SpellRare = { default = true, undercurl = true, },
        CursorLineNr = { fg = '#88c096' },
        LineNrAbove = { fg = '#77827c' },
        LineNrBelow = { fg = '#77827c' },
      },
    },
    enabled = false,
  },
}
