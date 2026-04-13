(vim.lsp.inline_completion.enable true)
(vim.api.nvim_create_autocmd
  "LspAttach"
  {:callback
   (fn [ev]
     (local client (assert (vim.lsp.get_client_by_id ev.data.client_id)))

     ;; turn off semantic tokens
     ;; this is the most reliable way, because some servers still advertise them
     (set client.server_capabilities.semanticTokensProvider nil)
     (vim.lsp.semantic_tokens.enable false {:bufnr ev.buf})

     ;; completion while typing
     (vim.lsp.completion.enable
       true
       client.id
       ev.buf
       {:autotrigger true})

     ;; optional: disable document colors too
     (vim.lsp.document_color.enable false {:bufnr ev.buf})

     ;; auto format on save
     (vim.api.nvim_create_autocmd
       "BufWritePre"
       {:buffer ev.buf
        :callback
        (fn []
          (vim.lsp.buf.format
            {:bufnr ev.buf
             :async false}))})

     ;; goto implementation
     ;; nvim already maps `gri` by default in recent versions,
     ;; but this makes it explicit per buffer.
     (vim.keymap.set
       "n"
       "gri"
       vim.lsp.buf.implementation
       {:buffer ev.buf
        :desc "LSP: goto implementation"}) )})
