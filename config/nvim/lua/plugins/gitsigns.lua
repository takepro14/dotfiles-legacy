-- plugins.lua
return {
  'lewis6991/gitsigns.nvim',
  lazy = true,
  event = { 'CursorHold', 'CursorHoldI' },
  config = function()
    require('gitsigns').setup({
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> · <summary> · <abbrev_sha>',
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', '<leader>gb', gs.toggle_current_line_blame)
        map('n', '<leader>gd', gs.diffthis)
      end,
    })
  end,
}
