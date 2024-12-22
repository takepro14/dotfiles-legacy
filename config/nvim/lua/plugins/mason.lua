return {
  -- Package manager for LSP servers, DAP servers, linters, and formatters
  'williamboman/mason.nvim',
  lazy = true,
  event = { 'CursorHold', 'CursorHoldI' },
  config = function()
    require('mason').setup({
      ui = {
        border = 'rounded',
      },
    })
  end,
}
