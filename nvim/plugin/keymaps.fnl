(fn set_n [key action opts]
	(vim.keymap.set "n" key action opts))

(set_n "<C-h>" "<C-w><C-h>")
(set_n "<C-j>" "<C-w><C-j>")
(set_n "<C-k>" "<C-w><C-k>")
(set_n "<C-l>" "<C-w><C-l>")


(set_n "<Esc>" "<cmd>nohlsearch<CR>")
(set_n "J" "mzJ`z")
(set_n "<C-d>" "<C-d>zz" { :desc "d + center"})
(set_n "<C-u>" "<C-u>zz" { :desc "u + center"})
(set_n "n" "nzzzv" { :desc "Next result and center"})
(set_n "N" "Nzzzv" { :desc "Prev result and center"})
(set_n "<leader>q" vim.diagnostic.setloclist)

(vim.keymap.set "t" "<Esc><Esc>" "<C-\\><C-n>")
(vim.keymap.set ["n" "v"] "<leader>y" "\"+y" { :noremap true :silent true})
(vim.keymap.set "x" "<leader>p" "\"_dP" { :desc "[P]aste and keep same text in copy buffer}" })

