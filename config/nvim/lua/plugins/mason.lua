return {
  -- Package manager for LSP servers, DAP servers, linters, and formatters
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup()
  end
}
