vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ctx)
    local set = vim.keymap.set
    set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = true })
    set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = true })
    set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = true })
    set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = true })
    set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = true })
    set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { buffer = true })
    set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { buffer = true })
    set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", { buffer = true })
    set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { buffer = true })
    set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = true })
    set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = true })
    set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = true })
    set("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", { buffer = true })
    set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { buffer = true })
    set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { buffer = true })
    set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", { buffer = true })
    set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", { buffer = true })
  end,
})

return {
  -- Enables easy configuration of Neovim's built-in LSP client
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "b0o/schemastore.nvim",
    }
  },
  -- Package manager for LSP servers, DAP servers, linters, and formatters
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  -- Enables easy configuration of `nvim-lspconfig` in a `Mason` environment
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      -- Auto install
      require("mason-lspconfig").setup {
        ensure_installed = {
          "html",
          "cssls",
          "tsserver",
          "ruby_lsp",
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
  },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lightbulb = {
        enable = false,
      },
      symbol_in_winbar = {
        separator = " > ",
      },
    },
    keys = {
      { "<Leader>ca", "<cmd>Lspsaga code_action<CR>",             { mode = { "n", "v" }, silent = true } },
      { "<Leader>rn", "<cmd>Lspsaga rename<CR>",                  { silent = true } },
      { "<Leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>",   { silent = true } },
      { "<Leaner>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true } },
      { "[e",         "<cmd>Lspsaga diagnostic_jump_next<CR>",    { silent = true } },
      { "]e",         "<cmd>Lspsaga diagnostic_jump_prev<CR>",    { silent = true } },
      {
        "[E",
        function()
          require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        { silent = true },
      },
      {
        "]E",
        function()
          require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
        end,
        { silent = true },
      },
      -- Callhierarchy
      { "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", { silent = true } },
      { "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", { silent = true } },
      -- Float terminal
      { "<Leader>i",  "<cmd>Lspsaga term_toggle<CR>",    { mode = { "n", "t" }, silent = true } },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded",
      },
      hint_enable = false,
      toggle_key = "<C-k>",
      select_signature_key = "<C-n>",
      floating_window_off_x = 5,       -- adjust float windows x position.
      floating_window_off_y = function() -- adjust float windows y position. e.g. set to -2 can make floating window move up 2 lines
        local pumheight = vim.o.pumheight
        local winline = vim.fn.winline() -- line number in the window
        local winheight = vim.fn.winheight(0)
        -- window top
        if winline - 1 < pumheight then
          return pumheight
        end
        -- window bottom
        if winheight - winline < pumheight then
          return -pumheight
        end
        return 0
      end,
    },
  }
}
