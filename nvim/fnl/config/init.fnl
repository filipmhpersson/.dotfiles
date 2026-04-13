(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")

(fn gh [package]
	{:src (.. "https://github.com/" package)})

(vim.pack.add
	[(gh "nvim-treesitter/nvim-treesitter")
	 (gh "stevearc/oil.nvim")
	 (gh "mason-org/mason.nvim")
	 (gh "stevearc/conform.nvim")
	 (gh "projekt0n/github-nvim-theme")
	 (gh "maxmx03/solarized.nvim")
	 (gh "neovim/nvim-lspconfig")
	 (gh "seblyng/roslyn.nvim")
	 (gh "ember-theme/nvim")
	])

(vim.lsp.enable "ts_go")
(vim.lsp.enable "rust_analyzer")
(vim.lsp.enable "zls")
(vim.lsp.enable "lua_ls")
(vim.lsp.enable "roslyn")

((. (require "nvim-treesitter") :install)
 ["lua" "fennel" "rust" "c_sharp" "c" "vim" "haskell" "zig" "markdown" "markdown_inline" "regex"])
(set vim.bo.indentexpr  "v:lua.require'nvim-treesitter'.indentexpr()")

(vim.cmd "packadd nvim.undotree")
(vim.keymap.set "n" "<leader>u" vim.cmd.Undotree)

((. (require "Oil") :setup))
(vim.keymap.set "n" "-" "<CMD>Oil<CR>")

((. (require "mason") :setup) 
 {:registries ["github:mason-org/mason-registry" "github:Crashdummyy/mason-registry"]})

(vim.api.nvim_set_hl 0 "LspCodeLens" {
  :fg "#5c6370"
  :italic true
})

(require "github-theme")
(require "solarized")


(vim.diagnostic.config {
  :virtual_text false
})
