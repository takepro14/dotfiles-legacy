return {
  "stevearc/conform.nvim",
  event = "BufReadPre",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        html = { "prettierd" },
        css = { "prettierd" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        json = { "prettierd" },
        markdown = { "prettierd" },
        sh = { "shfmt" },
        zsh = { "shfmt" },
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
