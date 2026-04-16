(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")

(fn gh [package]
	{:src (.. "https://github.com/" package) })

(vim.pack.add
	[
   (gh "nvim-lua/plenary.nvim")
   (gh "nvim-treesitter/nvim-treesitter")
	 (gh "stevearc/oil.nvim")
	 (gh "mason-org/mason.nvim")
	 (gh "stevearc/conform.nvim")
	 (gh "projekt0n/github-nvim-theme")
	 (gh "maxmx03/solarized.nvim")
	 (gh "neovim/nvim-lspconfig")
	 (gh "seblyng/roslyn.nvim")
	 (gh "ember-theme/nvim")
   (gh "windwp/nvim-autopairs")
   (gh "nvim-mini/mini.surround")
   (gh "nvim-mini/mini.ai")
	 (gh "ibhagwan/fzf-lua")
	 (gh "rebelot/kanagawa.nvim")
	 (gh "tpope/vim-fugitive")
   {:src "https://github.com/saghen/blink.cmp" :version "v1"}
	])
(vim.lsp.enable "ts_go")
(vim.lsp.enable "rust_analyzer")
(vim.lsp.enable "zls")
(vim.lsp.enable "lua_ls")
(vim.lsp.enable "roslyn")

(vim.keymap.set "n" "<leader>gs" vim.cmd.Git)


((. (require "nvim-treesitter") :install)
 ["lua" "fennel" "rust" "c_sharp" "c" "vim" "haskell" "zig" "markdown" "markdown_inline" "regex"])
(set vim.bo.indentexpr  "v:lua.require'nvim-treesitter'.indentexpr()")

(vim.cmd "packadd nvim.undotree")
(vim.keymap.set "n" "<leader>u" vim.cmd.Undotree)

((. (require "mini.surround") :setup))
((. (require "nvim-autopairs") :setup))
((. (require "mini.ai") :setup) { :n_lines 500})
((. (require "kanagawa") :setup) { :complie false :transparent false :colors { :theme { :all { :ui { :bg_gutter "none"}}}}})
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

 ((. (require "blink.cmp") :setup) {
     :keymap { :preset "default"}
     :appearance { :nerd_font_variant "mono" }
     :signature { :enabled true }
     :completion { :auto_show true :documentation { :auto_show false :auto_show_delay_ms  500 } }
     :sources { :default ["lsp" "path" "snippets" "buffer"] }
     :fuzzy { :implementation "rust" }})
