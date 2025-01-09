return {
  -- Enables easy configuration of `nvim-lspconfig` in a `Mason` environment
  'williamboman/mason-lspconfig.nvim',
  lazy = true,
  event = { 'CursorHold', 'CursorHoldI' },
  config = function()
    -- Auto install
    require('mason-lspconfig').setup({
      ensure_installed = {
        'html',
        'cssls',
        'ts_ls',
        'solargraph',
        'pylsp',
        'gopls',
        'lua_ls',
        'apex_ls',
        'clangd',
        'emmet_ls',
      },
    })
    -- Capabilities that LSP clients want the LSP server to provide
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities.offsetEncoding = { 'utf-16' }
    capabilities.textDocument.completion.completionItem = {
      documentationFormat = {
        'markdown',
        'plaintext',
      },
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = {
        valueSet = { 1 },
      },
      resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        },
      },
    }
    -- Setup handlers for installed all LSP servers
    require('mason-lspconfig').setup_handlers({
      function(server_name)
        local opts = { capabilities = capabilities }

        if server_name == 'gopls' then
          opts.settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
            },
          }
          opts.on_attach = function(client, bufnr)
            if client.server_capabilities.documentFormattingProvider then
              vim.api.nvim_create_autocmd('BufWritePre', {
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({ async = false })
                end,
              })
            end
          end
        end

        require('lspconfig')[server_name].setup(opts)
      end,
    })
  end,
}
