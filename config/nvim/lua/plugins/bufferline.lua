return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = true,
  event = { "BufReadPost", "BufAdd", "BufNewFile" },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
    },
  },
  keys = {
    { "<Tab>",     "<cmd>BufferLineCycleNext<CR>", { silent = true, noremap = true, desc = "Buffer Next" } },
    { "<S-Tab>",   "<cmd>BufferLineCyclePrev<CR>", { silent = true, noremap = true, desc = "Buffer Prev" } },
    { "<leader>w", ":bdelete<CR>",                 { silent = true, noremap = true } },
  },
}
