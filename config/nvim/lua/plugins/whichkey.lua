-- Useful plugin to show you pending keybinds.
return {
  'folke/which-key.nvim',
  event = "VeryLazy",

  opts = {
    keys = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>",   -- binding to scroll up inside the popup
    },
  },
  keys = {
    {
      "<leader>0",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    }
  },

  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)
    wk.add {
      -- document existing key chains group
      { "<leader>1",  group = "More git" },
      { "<leader>1_", hidden = true },
      { "<leader>c",  group = "[C]ode" },
      { "<leader>c_", hidden = true },
      { "<leader>d",  group = "[D]ocument" },
      { "<leader>d_", hidden = true },
      { "<leader>g",  group = "[G]it" },
      { "<leader>g_", hidden = true },
      { "<leader>h",  group = "[H]arpoon" },
      { "<leader>h_", hidden = true },
      { "<leader>r",  group = "[R]ename" },
      { "<leader>r_", hidden = true },
      { "<leader>s",  group = "[S]earch" },
      { "<leader>s_", hidden = true },
      { "<leader>w",  group = "[W]orkspace" },
      { "<leader>w_", hidden = true },
      { "<leader>n",  group = "[N]oice" },
      { "<leader>n_", hidden = true },
      { "f",          group = "Surround" },
      -- cpm keymaps
      { "<C-n>",      desc = "Completion: next item" },
      { "<C-p>",      desc = "Completion: previous item" },
      { "<C-d>",      desc = "Completion: float page scroll down" },
      { "<C-f>",      desc = "Completion: float page scroll up" },
      { "<M-Enter>",  desc = "Completion: auto completion result page" },
      -- surround keymaps
      { "sa",         desc = "add surrounding",                        mode = { "n", "v" } },
      { "sd",         desc = "delete surrounding ",                    mode = { "n", "v" } },
      { "sc",         desc = "change surrounding",                     mode = { "n", "v" } },
    }
  end
}
