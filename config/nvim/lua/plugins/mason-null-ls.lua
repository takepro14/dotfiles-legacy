return {
  'jay-babu/mason-null-ls.nvim',
  lazy = true,
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'williamboman/mason.nvim',
    'nvimtools/none-ls.nvim',
  },
  config = function()
    require('mason-null-ls').setup({
      ensure_installed = { 'stylua', 'prettier', 'clang_format' },
    })
  end,
}
