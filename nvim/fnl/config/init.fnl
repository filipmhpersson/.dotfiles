(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")

(fn gh [package]
	{:src (.. "https://github.com/" package) })

(vim.pack.add
	[
   (gh "nvim-lua/plenary.nvim")
   (gh "nvim-treesitter/nvim-treesitter")
   (gh "nvim-treesitter/nvim-treesitter-textobjects")
	 (gh "stevearc/oil.nvim")
	 (gh "mason-org/mason.nvim")
	 (gh "stevearc/conform.nvim")
	 (gh "neovim/nvim-lspconfig")
	 (gh "seblyng/roslyn.nvim")
   (gh "windwp/nvim-autopairs")
   (gh "nvim-mini/mini.surround")
   (gh "MeanderingProgrammer/render-markdown.nvim")
   (gh "nvim-mini/mini.ai")
	 (gh "ibhagwan/fzf-lua")
   (gh "sainnhe/gruvbox-material")
	 (gh "tpope/vim-fugitive")
   (gh "tpope/vim-dispatch")
   {:src "https://github.com/saghen/blink.cmp" :version "v1"}
	])

(vim.lsp.enable "tsgo")
(vim.lsp.enable "tsp_server")
(vim.lsp.enable "rust_analyzer")
(vim.lsp.enable "zls")
(vim.lsp.enable "lua_ls")
(vim.lsp.enable "basedpyright")

(set vim.g.gruvbox_material_better_performance 1)
(set vim.g.gruvbox_material_foreground "material")
(set vim.g.gruvbox_material_background "hard")
(set vim.g.lightlight { :colorscheme "gruvbox_material"})
(set vim.o.autowriteall true)


(pcall vim.cmd.colorscheme "gruvbox-material")


;(set vim.g.colorscheme "gruvbox_material")


(vim.keymap.set "n" "<leader>gs" vim.cmd.Git)

((. (require "nvim-treesitter") :install)
 ["lua" "fennel" "rust" "c_sharp" "c" "vim" "haskell" "zig" "markdown" "markdown_inline" "regex" "typescript" "tsx" "javascript" "jsx" "typespec"])
(set vim.bo.indentexpr  "v:lua.require''.indentexpr()")

(vim.cmd "packadd nvim.undotree")
(vim.keymap.set "n" "<leader>u" vim.cmd.Undotree)

((. (require "mini.surround") :setup))
((. (require "nvim-autopairs") :setup))
((. (require "render-markdown") :setup))
((. (require "nvim-treesitter-textobjects") :setup))
((. (require "mini.ai") :setup) { :n_lines 500})
((. (require "Oil") :setup))
(vim.keymap.set "n" "-" "<CMD>Oil<CR>")

((. (require "mason") :setup)
 {:registries ["github:mason-org/mason-registry" "github:Crashdummyy/mason-registry"]})
((. (require "conform") :setup) 
(let [javascript ["prettierd" "prettier"]]
  (tset javascript :stop_after_first true)
 {
 :format_on_save { :timeout 500 :lsp_format "fallback"}
 :formatters_by_ft {
    :javascript javascript
    :javascriptreact javascript
    :typescript javascript
    :typescriptreact  javascript
    :typespec  javascript
 }
 }))

(vim.api.nvim_set_hl 0 "LspCodeLens" {
  :fg "#5c6370"
  :italic true
})


(vim.diagnostic.config {
  :virtual_text true
  :virtual_lines false
})
(vim.keymap.set "n" "<leader>pt" ":Make test<cr>")
(vim.keymap.set "n" "<leader>pb" ":Make build<cr>")

((. (require "blink.cmp") :setup) {
      :keymap { :preset "default"}
      :appearance { :nerd_font_variant "mono" }
      :signature { :enabled true }
      :completion {  :documentation { :auto_show false :auto_show_delay_ms  500 } }
      :sources { :default ["lsp" "path" "snippets" "buffer"] }
      :fuzzy { :implementation "rust" }
      })
