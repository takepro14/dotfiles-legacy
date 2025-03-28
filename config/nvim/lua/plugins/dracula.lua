return {
  "Mofiqul/dracula.nvim",
  lazy = false,
  config = function()
    require("dracula").setup()
    vim.cmd("colorscheme dracula")
  end,
}
