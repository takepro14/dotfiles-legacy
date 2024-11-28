vim.loader.enable()
vim.g.mapleader = ' '
require('core.options')
require('core.lazy')
vim.cmd.colorscheme('dracula')

vim.cmd('highlight Normal guibg=NONE ctermbg=NONE')
vim.cmd('highlight NonText guibg=NONE ctermbg=NONE')
vim.cmd('highlight Visual guibg=#6272A4 guifg=NONE')
vim.cmd('highlight NvimTreeNormal guibg=NONE ctermbg=NONE')
vim.cmd('highlight BufferLineFill guibg=NONE ctermbg=NONE')
vim.cmd('highlight BufferLineBackground guibg=NONE ctermbg=NONE')
vim.cmd('highlight BufferLineBufferSelected guibg=NONE ctermbg=NONE')
vim.cmd('highlight BufferLineBufferVisible guibg=NONE ctermbg=NONE')
vim.cmd('highlight TabLineFill guibg=NONE ctermbg=NONE')
vim.cmd('highlight TabLine guibg=NONE ctermbg=NONE')
vim.cmd('highlight TabLineSel guibg=NONE ctermbg=NONE')
vim.cmd('highlight StatusLine guibg=NONE ctermbg=NONE')
vim.cmd('highlight StatusLineNC guibg=NONE ctermbg=NONE')
vim.cmd('highlight VertSplit guibg=NONE ctermbg=NONE')
vim.cmd('highlight LineNr guibg=NONE ctermbg=NONE')
vim.cmd('highlight CursorLineNr guibg=NONE ctermbg=NONE')
vim.cmd('highlight SignColumn guibg=NONE ctermbg=NONE')
vim.cmd('highlight EndOfBuffer guibg=NONE ctermbg=NONE')
vim.cmd('highlight TelescopeNormal guibg=NONE ctermbg=NONE')
vim.cmd('highlight TelescopeBorder guibg=NONE ctermbg=NONE')
vim.cmd('highlight TelescopePromptNormal guibg=NONE ctermbg=NONE')
vim.cmd('highlight TelescopePromptBorder guibg=NONE ctermbg=NONE')
vim.cmd('highlight TelescopeResultsNormal guibg=NONE ctermbg=NONE')
vim.cmd('highlight TelescopeResultsBorder guibg=NONE ctermbg=NONE')
vim.cmd('highlight TelescopePreviewNormal guibg=NONE ctermbg=NONE')
vim.cmd('highlight TelescopePreviewBorder guibg=NONE ctermbg=NONE')
vim.cmd('highlight CmpNormal guibg=NONE ctermbg=NONE')
vim.cmd('highlight CmpPmenu guibg=NONE ctermbg=NONE')
vim.cmd('highlight CmpPmenuSel guibg=NONE ctermbg=NONE')
vim.cmd('highlight CmpPmenuThumb guibg=NONE ctermbg=NONE')
vim.cmd('highlight CmpDocumentation guibg=NONE ctermbg=NONE')
vim.cmd('highlight CmpDocumentationBorder guibg=NONE ctermbg=NONE')

vim.cmd([[
  highlight DiffAdd    guibg=#3a5640 guifg=NONE ctermbg=DarkGreen ctermfg=NONE
  highlight DiffChange guibg=#4e437a guifg=NONE ctermbg=DarkBlue ctermfg=NONE
  highlight DiffDelete guibg=#603d3d guifg=NONE ctermbg=DarkRed ctermfg=NONE
  highlight DiffText   guibg=#6c5076 guifg=NONE ctermbg=DarkMagenta ctermfg=NONE
]])

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('core.autocmds')
    require('core.keymaps')
    require('core.lsp')
  end,
})
