return {
  "williamboman/mason-lspconfig.nvim",
  config = function()
    require("mason-lspconfig").setup {
      ensure_installed = {
        -- Zsh
        -- "shellcheck",
        -- "shfmt",
        -- HTML
        "html",
        -- "htmlhint",
        -- CSS
        "cssls",
        -- "stylelint",
        -- JavaScript
        "tsserver",
        "eslint",
        -- "prettier",
        -- Ruby
        "ruby_lsp",
        "rubocop",
        -- "rubyfmt",
        -- "erb-lint",
        -- "erb-formatter",
        -- Python
        "pylsp",
        -- "pylint",
        -- "black",
        -- Golang
        "gopls",
        -- "golangci-lint",
        -- "goimports",
        -- Lua
        "lua_ls",
        -- "luacheck",
        -- "stylua",
      }
    }
  end
}
