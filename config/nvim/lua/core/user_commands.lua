vim.api.nvim_create_user_command("CopyFullPath", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
  vim.notify("Copied full path to clipboard!")
end, {})

vim.api.nvim_create_user_command("CopyPath", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
  vim.notify("Copied relative path to clipboard!")
end, {})
