return {
  -- Enables easy configuration of `nvim-lspconfig` in a `Mason` environment
  "williamboman/mason-lspconfig.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI" },
  config = function()
    -- Auto install
    require("mason-lspconfig").setup {
      ensure_installed = {
        "html",
        "cssls",
        "tsserver",
        "solargraph",
        "pylsp",
        "gopls",
        "lua_ls",
      }
    }
    -- Capabilities that LSP clients want the LSP server to provide
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.offsetEncoding = { "utf-16" }
    capabilities.textDocument.completion.completionItem = {
      documentationFormat = {
        "markdown",
        "plaintext",
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
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      },
    }
    -- Setup handlers for installed all LSP servers
    require("mason-lspconfig").setup_handlers {
      function(server_name)
        require("lspconfig")[server_name].setup { capabilities = capabilities }
      end,
    }
  end
}
