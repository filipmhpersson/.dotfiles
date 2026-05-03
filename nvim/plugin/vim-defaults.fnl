(fn set_g [prop val]
	(tset vim.g prop val))

(fn set_opt [prop val]
	(tset vim.opt prop val))

(set_g "have_nerd_font" true)

(set_opt "termguicolors" true)

(set_opt "nu" true)
(set_opt "relativenumber" true)
(set_opt "cursorline" true)
(set_opt "hlsearch" true)
(set_opt "ignorecase" true)
(set_opt "smartcase" true)
(set_opt "inccommand" "split")
(set_opt "expandtab" true)
(set_opt "smartindent" true)

(set_opt "mouse" "a")
(set_opt "tabstop" 4)
(set_opt "softtabstop" 4)
(set_opt "shiftwidth" 4)
(set_opt "expandtab" true)
(set_opt "showmode" false)
(set_opt "breakindent" false)
(set_opt "wrap" false)

(set_opt "scrolloff" 10)
(set_opt "sidescrolloff" 10)
(set_opt "signcolumn" "yes")
(set_opt "autoindent" true)
(set_opt "updatetime" 250)
;(set_opt "timeoutlen" 300)

(set_opt "swapfile" false)
(set_opt "backup" false)
(set_opt "writebackup" false)
(set_opt "undodir" (.. (os.getenv "HOME") "/.vim/undodir"))
(set_opt "autoread" true)
(set_opt "autowrite" false)
(set_opt "undofile" true)
(set_opt "incsearch" true)
(set_opt "splitright" true)
(set_opt "splitbelow" true)
(vim.api.nvim_set_hl 0 "CursorLine" {:bg "NONE"})
(vim.api.nvim_set_hl 0 "WinSeparator" { :fg "bg" })



(vim.api.nvim_create_autocmd
	["CursorHold" "CursorHoldI"]
	{ :command "checktime" })

(vim.api.nvim_create_autocmd
	"TextYankPost"
	{ :group (vim.api.nvim_create_augroup "hl-yank" { :clear true})
	:callback (fn [] (vim.highlight.on_yank))})
