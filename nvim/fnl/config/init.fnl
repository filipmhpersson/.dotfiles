(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")

(fn gh [package]
	{:src (.. "https://github.com/" package)})

(vim.pack.add
	[(gh "nvim-treesitter/nvim-treesitter")
	 (gh "nvim-treesitter/nvim-treesitter-textobjects")
	 (gh "stevearc/oil.nvim")
	 (gh "mason-org/mason.nvim")
	 (gh "stevearc/conform.nvim")
	 (gh "projekt0n/github-nvim-theme")
	 (gh "neovim/nvim-lspconfig")
	])

(vim.lsp.enable "ts_go")
(vim.lsp.enable "rust_analyzer")
(vim.lsp.enable "zls")
(vim.lsp.enable "lua_ls")

((. (require "nvim-treesitter.configs") :setup)
 {:ensure_installed ["lua" "fennel" "rust" "c_sharp" "c" "vim" "haskell" "zig" "markdown" "markdown_inline" "regex"]
	:indent { :enable true }
	:auto_install true
	:sync_false false
	:ignore_installs {}
	:modles {}
	:highlight { :enable false :additional_vim_regex_highlighting false }})

(vim.cmd "packadd nvim.undotree")
(vim.keymap.set "n" "<leader>u" vim.cmd.Undotree)

((. (require "Oil") :setup))
(vim.keymap.set "n" "-" "<CMD>Oil<CR>")

(vim.cmd "colorscheme github_dark_dimmed")


((. (require "mason") :setup) 
 {:registries ["github:mason-org/mason-registry" "github:Crashdummyy/mason-registry"]})
