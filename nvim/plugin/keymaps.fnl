(lambda set_n [key action]
	(vim.keymap.set "n" key action))

(set_n "<C-h>" "<C-w><C-h>")
(set_n "<C-j>" "<C-w><C-j>")
(set_n "<C-k>" "<C-w><C-k>")
(set_n "<C-l>" "<C-w><C-l>")


(set_n "<Esc>" "<cmd>nohlsearch<CR>")
(set_n "J" "mzJ`z")
(set_n "<C-d>" "<C-d>zz")
(set_n "<C-u>" "<C-u>zz")
(set_n "n" "nzzzv")
(set_n "N" "Nzzzv")
(set_n "<leader>q" vim.diagnostic.setloclist)

(vim.keymap.set "t" "<Esc><Esc>" "<C-\\><C-n>")
(vim.keymap.set ["n" "v"] "<leader>y" "\"+y" { :noremap true :silent true})
