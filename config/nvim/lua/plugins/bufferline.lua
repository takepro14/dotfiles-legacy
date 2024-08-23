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
    { '<Tab>',     '<cmd>BufferLineCycleNext<CR>', { silent = true, noremap = true, desc = 'Buffer Next' } },
    { '<S-Tab>',   '<cmd>BufferLineCyclePrev<CR>', { silent = true, noremap = true, desc = 'Buffer Prev' } },
    -- <Tab> and <C-i> are the same key code, so <C-i> is set to do the vim default behavior
    { '<C-i>',     '<C-i>',                        { silent = true, noremap = true } },
    { '<leader>w', ':bdelete<CR>',                 { silent = true, noremap = true } },
  },
}
