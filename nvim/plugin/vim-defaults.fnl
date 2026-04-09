(fn set_g [prop val]
	(tset vim.g prop val))

(fn set_opt [prop val]
	(tset vim.opt prop val))

(set_g "mapleader" " ")
(set_g "maplocalleader" " ")

(set_opt "nu" true)
(set_opt "relativenumber" true)

