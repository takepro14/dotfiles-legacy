return {
  "glepnir/lspsaga.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "LspAttach",
  keys = {
    { "<Leader>ca", "<cmd>Lspsaga code_action<CR>", { mode = { "n", "v" }, silent = true, noremap = true } },
    { "<Leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true, noremap = true } },
    { "<Leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true, noremap = true } },
    { "<Leaner>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true, noremap = true } },
    { "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true, noremap = true } },
    { "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true, noremap = true } },
    {
      "[E",
      function()
        require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end,
      { silent = true, noremap = true },
    },
    {
      "]E",
      function()
        require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
      end,
      { silent = true, noremap = true },
    },
    -- Callhierarchy
    { "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", { silent = true, noremap = true } },
    { "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", { silent = true, noremap = true } },
    -- Float terminal
    { "<Leader>i", "<cmd>Lspsaga term_toggle<CR>", { mode = { "n", "t" }, silent = true, noremap = true } },
  },
  opts = {
    lightbulb = {
      enable = false,
    },
    symbol_in_winbar = {
      separator = " > ",
    },
  },
}
