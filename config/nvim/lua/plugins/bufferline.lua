return {
  'akinsho/bufferline.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = true,
  event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  opts = {
    options = {
      diagnostics = 'nvim_lsp',
    },
  },
  keys = {
    { '<leader>n', '<cmd>BufferLineCycleNext<CR>', { silent = true, noremap = true, desc = 'Buffer Next' } },
    { '<leader>p', '<cmd>BufferLineCyclePrev<CR>', { silent = true, noremap = true, desc = 'Buffer Prev' } },
    { '<leader>w', ':bdelete<CR>',                 { silent = true, noremap = true } },
  },
}
