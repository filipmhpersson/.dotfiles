(vim.treesitter.start)
(vim.cmd.compiler "dotnet")

;(set vim.b.dispatch "dotnet build")
(set vim.opt_local.makeprg "dotnet $*")

