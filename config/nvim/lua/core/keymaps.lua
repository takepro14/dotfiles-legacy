--[[
'' (an empty string)	mapmode-nvo	Normal, Visual, Select, Operator-pending
'n' Normal	:nmap
'v' Visual and Select
's' Select	:smap
'x' Visual	:xmap
'o' Operator-pending
'!' Insert and Command-line
'i' Insert	:imap
'l' Insert, Command-line, Lang-Arg
'c' Command-line
't' Terminal
--]]
local function opts(desc)
  return { desc = desc, noremap = true, silent = true }
end

-- Generic keymaps
local default_opts = { silent = true, noremap = true }
vim.keymap.set("n", "k", "gk", default_opts)
vim.keymap.set("n", "j", "gj", default_opts)
vim.keymap.set("n", "0", "g0", default_opts)
vim.keymap.set("n", "^", "g^", default_opts)
vim.keymap.set("n", "$", "g$", default_opts)
vim.keymap.set("n", "J", "10j", default_opts)
vim.keymap.set("n", "K", "10k", default_opts)
vim.keymap.set("n", "U", "<C-r>", default_opts)
vim.keymap.set("n", "<C-j>", "J", default_opts)
vim.keymap.set("n", "<space>", "<nop>", default_opts)
vim.keymap.set("v", "J", "10j", default_opts)
vim.keymap.set("v", "K", "10k", default_opts)
vim.keymap.set("v", "<C-j>", "J", default_opts)
vim.keymap.set("i", "<C-a>", "<Home>", default_opts)
vim.keymap.set("i", "<C-e>", "<End>", default_opts)
vim.keymap.set("i", "<C-p>", "<Up>", default_opts)
vim.keymap.set("i", "<C-n>", "<Down>", default_opts)
vim.keymap.set("i", "<C-f>", "<Right>", default_opts)
vim.keymap.set("i", "<C-b>", "<Left>", default_opts)
vim.keymap.set("i", "<C-h>", "<BS>", default_opts)
vim.keymap.set("i", "<C-d>", "<Del>", default_opts)

-- Functional keymaps
vim.keymap.set("i", "<C-l>", function()
  local line = vim.fn.getline(".")
  local col = vim.fn.getpos(".")[3]
  local substring = line:sub(1, col - 1)
  local result = vim.fn.matchstr(substring, [[\v<(\k(<)@!)*$]])
  return "<C-w>" .. result:upper()
end, { expr = true })
