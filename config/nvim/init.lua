vim.loader.enable()
vim.g.mapleader = " "
require("core.options")
require("core.lazy")
vim.cmd.colorscheme("dracula")
vim.cmd('highlight Normal guibg=none')
vim.cmd('highlight NonText guibg=none')
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("core.autocmd")
    require("core.keymap")
    require("core.lsp")
  end,
})
