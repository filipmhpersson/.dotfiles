(vim.treesitter.start)
(vim.cmd.compiler "dotnet")

;(set vim.b.dispatch "dotnet build")
(set vim.opt_local.makeprg "dotnet $*")

(vim.api.nvim_create_autocmd 
  "BufWritePre" 
  {
  :pattern "*.cs"
  :callback (fn [args]
    (vim.lsp.buf.format 
      {:bufnr args.buf
       :timeout_ms 3000}))})
