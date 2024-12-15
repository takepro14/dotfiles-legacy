-- tmp以下はundoファイルを作らない
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = vim.api.nvim_create_augroup('dont_create_undo', { clear = true }),
  pattern = { '/tmp/*' },
  command = 'setlocal noundofile',
})

-- ヤンク時にハイライト
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- qでヘルプを抜ける
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
  pattern = {
    'qf',
    'help',
    'man',
    'lspinfo',
    'checkhealth',
    'startuptime',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = event.buf, silent = true })
  end,
})

-- リサイズ時の調整
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = vim.api.nvim_create_augroup('resize_splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- ファイル変更時に警告を発する
vim.api.nvim_create_autocmd({ 'TermClose', 'TermLeave', 'FocusGained' }, {
  group = vim.api.nvim_create_augroup('warm', { clear = true }),
  command = 'checktime',
})

-- ファイルを開いた時に、カーソルの場所を復元する
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('restore_cursor', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ディレクトリが存在しない場合に自動生成する
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- 改行時のコメントアウトを無効
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  group = vim.api.nvim_create_augroup('disable_comment', { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
    vim.opt_local.formatoptions:append({ 'M', 'j' })
  end,
})

-- 末尾の空白を削除する
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  group = vim.api.nvim_create_augroup('TrimTrailingWhitespace', { clear = true }),
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

-- Markdown向けの編集設定
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    -- タブをスペース2つにする (デフォルト値の4つをオーバーライド)
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    -- 改行時のbullet引き継ぎなど
    vim.opt_local.comments = { 'b:*', 'b:-', 'b:+', 'b:1.', 'nb:>' }
    vim.opt_local.formatoptions:remove('c')
    vim.opt_local.formatoptions:append('jro')
    -- インサートモードでのインデントを可能にする
    vim.api.nvim_set_keymap('i', '>>', '<Esc>>>A', { noremap = true })
    vim.api.nvim_set_keymap('i', '<<', '<Esc><<A', { noremap = true })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
  end,
})

-- https://github.com/nvim-tree/nvim-tree.lua/discussions/2667
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#make-q-and-bd-work-as-if-tree-was-not-visible
-- Make :bd and :q behave as usual when tree is visible
vim.api.nvim_create_autocmd({ 'BufEnter', 'QuitPre' }, {
  nested = false,
  callback = function(e)
    local tree = require('nvim-tree.api').tree

    -- Nothing to do if tree is not opened
    if not tree.is_visible() then
      return
    end

    -- How many focusable windows do we have? (excluding e.g. incline status window)
    local winCount = 0
    for _, winId in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(winId).focusable then
        winCount = winCount + 1
      end
    end

    -- We want to quit and only one window besides tree is left
    if e.event == 'QuitPre' and winCount == 2 then
      vim.api.nvim_cmd({ cmd = 'qall' }, {})
    end

    -- :bd was probably issued an only tree window is left
    -- Behave as if tree was closed (see `:h :bd`)
    if e.event == 'BufEnter' and winCount == 1 then
      -- Required to avoid "Vim:E444: Cannot close last window"
      vim.defer_fn(function()
        -- close nvim-tree: will go to the last buffer used before closing
        tree.toggle({ find_file = true, focus = true })
        -- re-open nivm-tree
        tree.toggle({ find_file = true, focus = false })
      end, 10)
    end
  end,
})
