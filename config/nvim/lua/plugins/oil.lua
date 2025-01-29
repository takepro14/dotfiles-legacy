return {
  'stevearc/oil.nvim',
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = true,
  keys = {
    { '<Leader>o', '<cmd>Oil<CR>', silent = true, desc = 'Open Oil window' },
    { 'q',         '<cmd>bd<CR>',  silent = true, desc = 'Close Oil window' },
  },
  config = function()
    require('oil').setup({
      columns = { 'icon', 'git_status' },
      view_options = {
        show_hidden = true,
      },
      win_options = {
        signcolumn = 'yes:2',
      },
    })
  end,
}
