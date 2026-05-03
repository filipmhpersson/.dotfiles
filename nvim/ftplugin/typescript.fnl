
(set vim.opt_local.shiftwidth 2)
(set vim.opt_local.softtabstop 2)
(set vim.opt_local.tabstop 2)
(vim.treesitter.start)

(vim.api.nvim_create_autocmd 
  "BufWritePre" 
  {
  :pattern "*.ts"
  :callback (fn [args]
    (vim.lsp.buf.format 
      {:bufnr args.buf
       :timeout_ms 3000}))})
