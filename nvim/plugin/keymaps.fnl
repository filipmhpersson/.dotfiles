(lambda set_n [key action]
	(vim.keymap.set "n" key action))

(set_n "<C-h>" "<C-w><C-h>")
(set_n "<C-j>" "<C-w><C-j>")
(set_n "<C-k>" "<C-w><C-k>")
(set_n "<C-l>" "<C-w><C-l>")



