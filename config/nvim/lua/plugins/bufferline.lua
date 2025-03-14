return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = { "BufReadPost", "BufAdd", "BufNewFile" },
  keys = {
    { "<leader>n", "<cmd>BufferLineCycleNext<CR>", { silent = true, noremap = true } },
    { "<leader>p", "<cmd>BufferLineCyclePrev<CR>", { silent = true, noremap = true } },
    { "<leader>w", ":bdelete<CR>", { silent = true, noremap = true } },
    { "<leader><S-n>", "<cmd>BufferLineMoveNext<CR>", { silent = true, noremap = true } },
    { "<leader><S-p>", "<cmd>BufferLineMovePrev<CR>", { silent = true, noremap = true } },
    { "<leader><S-w>", "<cmd>BufferLineCloseOthers<CR>", { silent = true, noremap = true } },
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
    },
  },
}
