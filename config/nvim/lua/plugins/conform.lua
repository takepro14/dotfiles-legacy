return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
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
