(fn set_g [prop val]
	(tset vim.g prop val))

(fn set_opt [prop val]
	(tset vim.opt prop val))

(set_g "have_nerd_font" true)

(set_opt "nu" true)
(set_opt "relativenumber" true)
(set_opt "cursorline" true)
(set_opt "hlsearch" true)
(set_opt "ignorecase" true)
(set_opt "smartcase" true)
(set_opt "inccommand" "split")

(vim.api.nvim_create_autocmd
	"TextYankPost"
	{ :group (vim.api.nvim_create_augroup "hl-yank" { :clear true})
	:callback (fn [] (vim.highlight.on_yank))})
