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
    -- herdr injects HERDR_PANE_ID into panes but NOT HERDR_BIN_PATH, so resolve
    -- the binary via PATH (exepath) with a couple of common install fallbacks.
    local function herdr_bin()
      local b = vim.env.HERDR_BIN_PATH
      if b and b ~= "" then
        return b
      end
      local p = vim.fn.exepath("herdr")
      if p ~= "" then
        return p
      end
      for _, c in ipairs({
        vim.fn.expand("~/.local/bin/herdr"),
        "/opt/homebrew/bin/herdr", -- macOS Apple Silicon (brew)
        "/usr/local/bin/herdr", -- macOS Intel (brew)
        "/usr/bin/herdr", -- Linux (AUR/pkg)
      }) do
        if vim.fn.executable(c) == 1 then
          return c
        end
      end
      return "herdr"
    end

    -- TEMP DEBUG (remove after diagnosing): log each nav call to ~/herdr-nav-nvim.log
    local function dbg(msg)
      local f = io.open(vim.fn.expand("~/herdr-nav-nvim.log"), "a")
      if f then
        f:write(os.date("%H:%M:%S") .. " " .. msg .. "\n")
        f:close()
      end
    end

    local function nav(wincmd, dir)
      local prev = vim.api.nvim_get_current_win()
      vim.cmd("wincmd " .. wincmd)
      local moved = vim.api.nvim_get_current_win() ~= prev
      dbg(string.format("nav dir=%s wincmd=%s moved_in_nvim=%s HERDR_PANE_ID=%s",
        dir, wincmd, tostring(moved), tostring(vim.env.HERDR_PANE_ID)))
      if moved then
        return -- moved within Neovim
      end
      if vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
        -- Single-window nvim relies entirely on this handoff to cross into the
        -- neighbouring herdr pane. Surface failures instead of dying silently.
        local out = vim.fn.system({ herdr_bin(), "pane", "focus", "--direction", dir, "--current" })
        dbg(string.format("  handoff bin=%s dir=%s exit=%s out=%s",
          herdr_bin(), dir, tostring(vim.v.shell_error), (out or ""):gsub("%s+", " ")))
        if vim.v.shell_error ~= 0 then
          vim.notify("herdr nav failed (" .. dir .. "): " .. out, vim.log.levels.WARN)
        end
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
