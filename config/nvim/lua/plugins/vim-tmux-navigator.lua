return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  init = function()
    -- We define our own <C-h/j/k/l> below; disable the plugin's default maps.
    vim.g.tmux_navigator_no_mappings = 1
  end,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  config = function()
    -- Seamless <C-h/j/k/l>: move between Neovim splits, and at a split edge hand
    -- off to the surrounding multiplexer — herdr when inside a herdr pane,
    -- tmux when inside tmux, plain wincmd otherwise. Chosen at runtime, so the
    -- same config works in both (tmux stays primary; herdr is opt-in via env).
    local function nav(wincmd, dir)
      local prev = vim.api.nvim_get_current_win()
      vim.cmd("wincmd " .. wincmd)
      if vim.api.nvim_get_current_win() ~= prev then
        return -- moved within Neovim
      end
      if vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
        local herdr = vim.env.HERDR_BIN_PATH
        if herdr == nil or herdr == "" then
          herdr = "herdr"
        end
        vim.fn.system({ herdr, "pane", "focus", "--direction", dir, "--current" })
      elseif vim.env.TMUX and vim.env.TMUX ~= "" then
        local t = { left = "Left", down = "Down", up = "Up", right = "Right" }
        pcall(vim.cmd, "TmuxNavigate" .. t[dir])
      end
    end

    local function map(lhs, wincmd, dir)
      vim.keymap.set("n", lhs, function()
        nav(wincmd, dir)
      end, { silent = true, noremap = true, desc = "Navigate " .. dir .. " (nvim/herdr/tmux)" })
    end

    map("<C-h>", "h", "left")
    map("<C-j>", "j", "down")
    map("<C-k>", "k", "up")
    map("<C-l>", "l", "right")
    -- tmux-only "last pane" toggle, unchanged from your setup
    vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { silent = true, desc = "Navigate previous (tmux)" })
  end,
}
