return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.6',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
    version = '^1.0.0',
  },
  lazy = true,
  keys = {
    { '<leader>ff', '<cmd>Telescope find_files<CR>', {} },
    { '<leader>fg', '<cmd>Telescope live_grep<CR>',  {} },
    { '<leader>fb', '<cmd>Telescope buffers<CR>',    {} },
    { '<leader>fh', '<cmd>Telescope help_tags<CR>',  {} },
  },
  config = function()
    local telescope = require('telescope')

    telescope.setup({
      telescope.load_extension('live_grep_args'),
      defaults = {
        file_ignore_patterns = {
          '.git/',
          '.dropbox.cache/',
          'node_modules/',
          'tmp/',
        },
        path_display = function(_, path)
          local tail = require('telescope.utils').path_tail(path)
          local dirname = path:match('(.*)/' .. tail) or '.'
          return string.format('%s (%s)', tail, dirname)
        end,
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = true,
        },
      },
    })
  end,
}
