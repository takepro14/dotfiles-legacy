return {
  -- Package manager for LSP servers, DAP servers, linters, and formatters
  'williamboman/mason.nvim',
  lazy = true,
  event = { 'CursorHold', 'CursorHoldI' },
  config = function()
    require('mason').setup()
  end,
}
