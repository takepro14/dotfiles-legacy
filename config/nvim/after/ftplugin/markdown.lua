function _G.markdown_outline()
  local fname = vim.fn.expand('%')
  local current_win_id = vim.fn.win_getid()

  -- # heading
  vim.cmd('vimgrep /^#\\{1,6} .*$/j ' .. fname)

  -- heading
  -- ===
  vim.cmd('vimgrepadd /\\zs\\S\\+\\ze\\n[=-]\\+$/j ' .. fname)

  local qflist = vim.fn.getqflist()
  if vim.tbl_isempty(qflist) then
    vim.cmd('cclose')
    return
  end

  -- Return to original window to ensure synID works
  vim.fn.win_gotoid(current_win_id)

  -- コードブロック内の行を無視する処理
  qflist = vim.tbl_filter(function(val)
    -- 行の先頭のシンタックスグループを取得
    local synname = vim.fn.synIDattr(vim.fn.synID(val.lnum, 1, 1), 'name') -- 常に1列目を確認
    -- markdownCodeBlock シンタックスが適用されている行を無視
    return synname ~= 'markdownCodeBlock'
  end, qflist)

  -- ソート
  table.sort(qflist, function(a, b)
    return a.lnum < b.lnum
  end)

  -- Quickfixリストに設定
  vim.fn.setqflist(qflist)
  vim.fn.setqflist({}, 'r', { title = fname .. ' TOC' })
  vim.cmd('copen')
end

-- キーマッピングを設定 (Markdownファイル内でのみ有効)
vim.api.nvim_buf_set_keymap(0, 'n', 'gO', '<Cmd>lua _G.markdown_outline()<CR>', { noremap = true, silent = true })
