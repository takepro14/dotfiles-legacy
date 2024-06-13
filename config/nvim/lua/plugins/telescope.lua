return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.6',
  dependencies = {
    'nvim-lua/plenary.nvim',
    "nvim-telescope/telescope-live-grep-args.nvim",
    version = "^1.0.0"
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", {} },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>",              {} },
    { "<leader>fb", "<cmd>Telescope buffers<CR>",                {} },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>",              {} }
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      telescope.load_extension("live_grep_args")
    })
  end
}
