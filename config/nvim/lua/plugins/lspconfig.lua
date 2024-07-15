return {
  -- Enables easy configuration of Neovim's built-in LSP client
  "neovim/nvim-lspconfig",
  lazy = true,
  event = { "CursorHold", "CursorHoldI" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "b0o/schemastore.nvim",
  }
}
