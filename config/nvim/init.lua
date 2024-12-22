vim.loader.enable()
vim.g.mapleader = ' '
require('core.options')
require('core.lazy')
require('core.colors')

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('core.autocmds')
    require('core.keymaps')
    require('core.lsp')
  end,
})
