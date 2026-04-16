-- init.lua
vim.pack.add({
  {
    src = "https://github.com/rktjmp/hotpot.nvim",
    version = vim.version.range("^2.0.0")
  }
})
require("hotpot")
require("config")
require("config.lappearance").setup()
require("config.lualine").setup()
require("config.fzflua")
local bg = "#1f1f28" -- or your exact background

vim.api.nvim_set_hl(0, "Normal", { bg = bg })
vim.api.nvim_set_hl(0, "NormalNC", { bg = bg })

vim.api.nvim_set_hl(0, "StatusLine", { bg = bg })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = bg })

vim.api.nvim_set_hl(0, "WinBar", { bg = bg })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = bg })

vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = bg })

vim.api.nvim_set_hl(0, "Pmenu", { bg = bg })
