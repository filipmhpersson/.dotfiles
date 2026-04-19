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
-- -- Optional: make floating windows match
-- set_hl(0, "NormalFloat", { bg = "#20242a" })
-- set_hl(0, "FloatBorder", { fg = "#5c6370", bg = "#20242a" })
--
-- -- VERY slight desaturation (closer to stock)
-- -- Blues: just toned down a bit, not shifted
--
-- -- Greens: slightly less vivid, still clearly green
--
-- -- Mute blues a bit
-- set_hl(0, "Function", { fg = "#6c8fb3" })
-- set_hl(0, "@function", { fg = "#6c8fb3" })
-- set_hl(0, "Identifier", { fg = "#7fa0c7" })
-- set_hl(0, "@property", { fg = "#7a97b8" })
-- set_hl(0, "@variable", { fg = "#c0c5ce" })

-- Mute greens a bit
-- set_hl(0, "String", { fg = "#98b36c" })
-- set_hl(0, "@string", { fg = "#98b36c" })
-- set_hl(0, "Directory", { fg = "#7ea06a" })
-- set_hl(0, "@keyword.return", { fg = "#7ea06a" })
