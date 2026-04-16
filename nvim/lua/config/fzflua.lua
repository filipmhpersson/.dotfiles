local FzfLua = require("fzf-lua")

-- 1) Exclude lockfiles from grep (ripgrep globs)
local LOCK_GLOB_EXCLUDES = {
  "!package-lock.json",
  "!pnpm-lock.yaml",
  "!yarn.lock",
  "!bun.lockb",
  "!nvim-pack-lock.json",
}

local function rg_opts_with_lock_excludes()
  local base = table.concat({
    "--column",
    "--line-number",
    "--no-heading",
    "--color=always",
    "--smart-case",
    "--max-columns=4096",
  }, " ")

  local globs = {}
  for _, g in ipairs(LOCK_GLOB_EXCLUDES) do
    table.insert(globs, ("--glob %q"):format(g))
  end

  return base .. " " .. table.concat(globs, " ")
end

-- 2) Emacs-like bottom dock + responsive right preview
local MIN_COLS_FOR_PREVIEW = 120

local function want_preview()
  return vim.o.columns >= MIN_COLS_FOR_PREVIEW
end

local function bottom_winopts_responsive()
  return {
    height = 0.30,
    width = 1.0,
    row = 1.0,
    col = 0.5,
    border = "none",
    preview = {
      hidden = not want_preview(),
      layout = "horizontal",
      horizontal = "right:55%",
      border = "noborder",
    },
  }
end

FzfLua.setup({
  fzf_opts = {
    ["--layout"] = "reverse",
  },

  -- Core pickers use a bottom dock with optional right preview
  files = {
    winopts = bottom_winopts_responsive, -- function => recalculated each open
  },

  grep = {
    winopts = bottom_winopts_responsive, -- function => recalculated each open
    rg_opts = rg_opts_with_lock_excludes(),
  },
})

-- KEYMAPS ------------------------------------------------------------

-- Files
vim.keymap.set("n", "<leader>sf", function()
  FzfLua.files()
end, { desc = "[S]earch [F]iles" })

-- Neovim config files
vim.keymap.set("n", "<leader>sc", function()
  FzfLua.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim [C]onfig" })

-- Live grep
vim.keymap.set("n", "<leader>sg", function()
  FzfLua.live_grep()
end, { desc = "[S]earch by [G]rep" })

-- Other pickers (leave as-is; they can still use their defaults)
vim.keymap.set("n", "<leader>sh", function()
  FzfLua.helptags()
end, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", function()
  FzfLua.keymaps()
end, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>ss", function()
  FzfLua.builtin()
end, { desc = "[S]earch [S]elect Picker" })
vim.keymap.set("n", "<leader>sw", function()
  FzfLua.grep_cword({
    winopts = bottom_winopts_responsive,
    rg_opts = rg_opts_with_lock_excludes(),
  })
end, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sm", function()
  FzfLua.marks()
end, { desc = "[S]earch [marks]" })
vim.keymap.set("n", "<leader>sd", function()
  FzfLua.diagnostics_workspace()
end, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>se", function()
  FzfLua.diagnostics_workspace({ severity_only = "Error" })
end, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", function()
  FzfLua.resume()
end, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", function()
  FzfLua.oldfiles()
end, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", function()
  FzfLua.buffers()
end, { desc = "[ ] Find existing buffers" })

-- Zen toggle
vim.keymap.set("n", "<leader>z", function()
  Zen.toggle()
end, { desc = "Toggle [Z]en" })

-- Backdrop highlight sync
local function set_fzflua_backdrop_to_normal()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  if normal and normal.bg then
    vim.api.nvim_set_hl(0, "FzfLuaBackdrop", { bg = normal.bg })
  end
end

set_fzflua_backdrop_to_normal()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_fzflua_backdrop_to_normal })
