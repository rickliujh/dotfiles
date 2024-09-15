return {
  'echasnovski/mini.surround',
  version = '*',
  opts = {
    mappings = {
      add = 'f',          -- Add surrounding in Normal and Visual modes
      delete = 'fd',       -- Delete surrounding
      replace = 'fc',      -- Replace surrounding
    },
  }
}

-- return {
--   "kylechui/nvim-surround",
--   version = "*",   -- Use for stability; omit to use `main` branch for the latest features
--   event = "VeryLazy",
--   config = function()
--     require("nvim-surround").setup({
--       keymaps = {
--         normal = "fs",
--         normal_cur = "fsc",
--         normal_line = "fsl",
--         normal_cur_line = "fscl",
--         visual = "fs",
--         visual_line = "fsl",
--         delete = "fd",
--         change = "fc",
--         change_line = "fcl",
--       },
--     })
--   end
-- }
