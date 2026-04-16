(vim.treesitter.start)
(vim.api.nvim_create_autocmd 
  "BufWritePre" 
  {
  :pattern "*.cs"
  :callback (fn [args]
    (vim.lsp.buf.code_action 
      { :context { :only  [ "source" ] }
      :apply true
    })
    (vim.lsp.buf.format 
      {:bufnr args.buf
       :timeout_ms 3000}))})
