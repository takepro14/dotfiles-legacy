return {
  -- Enables easy configuration of Neovim's built-in LSP client
  "neovim/nvim-lspconfig",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "b0o/schemastore.nvim",
  },
  config = function()
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

    local lspconfig = require("lspconfig")

    -- The servers that can be configurable are written below.
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    local servers = {
      html = {},
      cssls = {},
      ts_ls = {},
      solargraph = {},
      pyright = {},
      clangd = {},
      gopls = {
        gofumpt = true,
        usePlaceholders = true,
        completeUnimported = true,
        analyses = {
          unusedparams = true,
          nilness = true,
          shadow = true,
          unusedvariable = true,
        },
        staticcheck = true,
        directoryFilters = { "-node_modules" },
      },
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } }, -- Prevent warnings for the `vim` global variable.
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true), -- Enable completion for Neovim runtime files.
              checkThirdParty = false, -- Disable warnings for third-party libraries.
            },
            telemetry = { enable = false }, -- Disable telemetry data collection.
          },
        },
      },
    }

    for server, config in pairs(servers) do
      config.capabilities = capabilities
      lspconfig[server].setup(config)
    end
  end,
}
