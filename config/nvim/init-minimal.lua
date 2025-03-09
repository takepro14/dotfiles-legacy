local default_opts = { silent = true, noremap = true }
local keymap = vim.keymap
local opt = vim.opt
keymap.set("n", "k", "gk", default_opts)
keymap.set("n", "j", "gj", default_opts)
keymap.set("n", "0", "g0", default_opts)
keymap.set("n", "^", "g^", default_opts)
keymap.set("n", "$", "g$", default_opts)
keymap.set("i", "jj", "<ESC>")
keymap.set("i", "<C-a>", "<Home>", default_opts)
keymap.set("i", "<C-e>", "<End>", default_opts)
keymap.set("i", "<C-p>", "<Up>", default_opts)
keymap.set("i", "<C-n>", "<Down>", default_opts)
keymap.set("i", "<C-f>", "<Right>", default_opts)
keymap.set("i", "<C-b>", "<Left>", default_opts)
keymap.set("i", "<C-h>", "<BS>", default_opts)
keymap.set("i", "<C-d>", "<Del>", default_opts)
opt.number = true
opt.cursorline = true
opt.confirm = true
opt.clipboard = { "unnamed", "unnamedplus" }
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.list = true
opt.listchars = { space = "·" }
