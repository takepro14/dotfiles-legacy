return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview" },
  keys = {
    { "<leader>mdp", "<cmd>MarkdownPreview<CR>", { silent = true, noremap = true } },
  },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
}
