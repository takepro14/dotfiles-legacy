vim.loader.enable()
vim.g.mapleader = ' '
require('core.options')
require('core.lazy')

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('core.autocmds')
    require('core.user_commands')
    require('core.keymaps')
    require('core.lsp')
  end,
})
