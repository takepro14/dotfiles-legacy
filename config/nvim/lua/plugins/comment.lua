return {
  "numToStr/Comment.nvim",
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
  event = "UIEnter",
  opts = {
    enable_autocmd = false,
    toggler = { line = "<Leader>/" }, -- for single line
    opleader = { line = "<Leader>/" }, -- for multiple lines
    extra = { eol = "<Leader>a" },
    pre_hook = function()
      require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
    end,
  },
}
