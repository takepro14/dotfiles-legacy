return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>gd", "<cmd>Gitsigns preview_hunk<CR>", { silent = true, noremap = true } },
  },
  config = function()
    require("gitsigns").setup({
      current_line_blame = true,
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> · <summary> · <abbrev_sha>",
    })
  end,
}
