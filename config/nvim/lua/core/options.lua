local opt = vim.opt
opt.number = true
opt.cursorline = true
opt.confirm = true
opt.title = true
opt.cmdheight = 1
opt.termguicolors = true
opt.updatetime = 100
opt.textwidth = 0
opt.signcolumn = 'auto'
opt.background = 'dark'
opt.clipboard = { 'unnamed', 'unnamedplus' }
opt.tabstop = 2
opt.shiftwidth = 2
opt.inccommand = 'split'
opt.showmatch = true
opt.matchtime = 1
opt.swapfile = false
opt.shadafile = 'NONE'
opt.mouse = 'a'
opt.fileencoding = 'utf-8'
opt.spelllang = 'en_us'
opt.fileformats = { 'unix', 'dos', 'mac' }
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.wrapscan = true
opt.hlsearch = true
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.timeout = true
opt.timeoutlen = 300
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.linebreak = true
opt.list = true
opt.listchars = { space = '·', tab = '> ' }
opt.ttimeoutlen = 1
opt.virtualedit = 'onemore'
opt.visualbell = true
opt.wildignore =
'.git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**'
opt.fileencoding = 'utf-8'
opt.whichwrap = 'b,s,h,l,[,],<,>,~'
opt.undodir = vim.fn.stdpath('state')
opt.undofile = true
opt.fillchars:append('eob: ')
opt.helplang = { 'ja', 'en' }
opt.wrap = true
opt.fillchars = { fold = ' ' }
opt.foldmethod = 'indent'
opt.foldenable = false
opt.foldlevel = 99
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.cmd.aunmenu({ 'PopUp.How-to\\ disable\\ mouse' })
vim.cmd.aunmenu({ 'PopUp.-1-' })
