return {
  "numToStr/Comment.nvim",
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
  event = "UIEnter",
  opts = {
    enable_autocmd = false,
    toggler = { line = "<leader>/" }, -- for single line
    opleader = { line = "<leader>/" }, -- for multiple lines
    extra = { eol = "<leader>a" },
    pre_hook = function()
      require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
    end,
  },
}
