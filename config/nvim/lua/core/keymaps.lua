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

local default_opts = { silent = true, noremap = true }
vim.keymap.set("n", "<ESC>", "<CMD>nohlsearch<CR><ESC>", opts("No highlight search"))
vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], opts("Exit the terminal"))
vim.keymap.set("i", "<tab>", "<C-v><tab>", opts("tab"))
vim.keymap.set("n", "k", "gk", default_opts)
vim.keymap.set("n", "j", "gj", default_opts)
vim.keymap.set("n", "0", "g0", default_opts)
vim.keymap.set("n", "^", "g^", default_opts)
vim.keymap.set("n", "$", "g$", default_opts)

-- LSP
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Pre diagnostic"))

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local function lsp(desc)
      if desc then
        desc = "LSP: " .. desc
      end
      return { desc = desc, buffer = ev.buf }
    end
    vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, lsp("[R]e[n]ame"))
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, lsp("signature"))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, lsp("[G]oto [D]eclaration"))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, lsp("[G]oto [I]mplementation"))
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, lsp("[G]oto [D]efinition"))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, lsp("[G]oto [R]eferences"))
    vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, lsp("[W]orkspace [A]dd folder"))
    vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, lsp("[W]orkspace [R]emove folder"))
    vim.keymap.set("n", "<Leader>wl", function()
      vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, lsp("[Workspace] [L]ist folders"))
    vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, lsp("type [D]efinition"))
    vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, lsp("[C]ode [A]ction"))
  end,
})
