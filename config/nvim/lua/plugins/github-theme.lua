return {
  {
    'projekt0n/github-nvim-theme',
    lazy = false,
    config = function()
      require('github-theme').setup({
        groups = {
          all = {
            Cursor = { fg = '#ffffff', bg = '#3578e5' },
          },
        },
      })
      vim.o.guicursor = 'n-v-c:block-Cursor/lCursor,i:ver25-Cursor'
      vim.cmd('colorscheme github_light')
    end,
  },
}
