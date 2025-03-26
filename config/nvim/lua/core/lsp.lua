vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
  focusable = false,
})
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })

vim.diagnostic.config({
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  signs = {
    text = { "", "", "", "" },
    numhl = {
      "DiagnosticSignError",
      "DiagnosticSignWarn",
      "DiagnosticSignInfo",
      "DiagnosticSignHint",
    },
    linehl = {
      "DiagnosticSignError",
      "DiagnosticSignWarn",
      "DiagnosticSignInfo",
      "DiagnosticSignHint",
    },
  },
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    local set = vim.keymap.set
    local default_opts = { buffer = true, silent = true, noremap = true }

    set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", default_opts)
    set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", default_opts)
    set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", default_opts)
    set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", default_opts)

    set("n", "<leader>h", "<cmd>lua vim.lsp.buf.hover()<CR>", default_opts)
    set("n", "<leader>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", default_opts)

    set("n", "<leader>do", vim.diagnostic.open_float, default_opts)
    set("n", "<leader>dn", vim.diagnostic.goto_next, default_opts)
    set("n", "<leader>dp", vim.diagnostic.goto_prev, default_opts)

    set("n", "<leader>en", function()
      vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
    end, default_opts)

    set("n", "<leader>ep", function()
      vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end, default_opts)
  end,
})
