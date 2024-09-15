return {
  "kylechui/nvim-surround",
  version = "*",   -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "sa",
        normal_cur = "sas",
        normal_line = "Sa",
        normal_cur_line = "SSa",
        visual = "S",
        visual_line = "gS",
        delete = "sd",
        change = "sc",
        change_line = "Sc",
      },
    })
  end
}
