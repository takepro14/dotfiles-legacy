return {
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = true,
  },
  {
    "uga-rosa/cmp-dictionary",
    event = "InsertEnter",
    opts = {
      paths = { "/usr/share/dict/words" },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "folke/which-key.nvim",
    cmd = "WhichKey",
    config = true,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },
  {
    "max397574/better-escape.nvim",
    opts = {
      mapping = { "kj", "jj" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    config = true,
    event = "InsertEnter",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = { enable_autocmd = false },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "CursorMoved",
  },
}
