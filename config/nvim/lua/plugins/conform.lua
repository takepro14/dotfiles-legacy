return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        markdown = { "prettierd" },
        ruby = { "rubocop" },
        python = { "black", "isort" },
        go = { "goimports" },
        lua = { "stylua" },
      },
      format_on_save = {
        lsp_format = false,
        timeout_ms = 500,
      },
    })
  end,
}
