local opt = vim.opt

-- UI
opt.number = true
opt.cursorline = true
opt.signcolumn = "auto"
opt.termguicolors = true
opt.list = true
opt.listchars = { space = "·", tab = "> " }
opt.fillchars = { fold = " " }
opt.fillchars:append("eob: ")

-- Operability
opt.confirm = true
opt.visualbell = true
opt.updatetime = 300
opt.timeoutlen = 300
opt.mouse = "a"
opt.linebreak = true
opt.whichwrap = "h,l"
opt.virtualedit = "onemore"
opt.completeopt = { "menu", "menuone", "noselect" }

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

-- Indentation
-- (Additional settings are in config/nvim/after/ftplugin/*.lua)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- File handling
opt.fileencoding = "utf-8"
opt.fileformats = { "unix", "dos", "mac" }
opt.clipboard = { "unnamed", "unnamedplus" }

-- History
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state")
opt.shadafile = "NONE"

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
