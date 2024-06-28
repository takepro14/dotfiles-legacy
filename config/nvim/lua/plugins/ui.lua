local function tree_keys(bufnr)
  local api = require("nvim-tree.api")
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  -- default mappings
  api.config.mappings.default_on_attach(bufnr)
  -- custom mappings
  vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup {
        options = {
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = { 'filename', 'diff' },
          lualine_x = { 'diagnostics' },
          lualine_y = { 'encoding' },
          lualine_z = { 'location' }
        }
      }
    end
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
      },
    },
    keys = {
      { "<Tab>",     "<cmd>BufferLineCycleNext<CR>", { silent = true, noremap = true, desc = "Buffer Next" } },
      { "<S-Tab>",   "<cmd>BufferLineCyclePrev<CR>", { silent = true, noremap = true, desc = "Buffer Prev" } },
      { "<leader>w", ":bdelete<CR>",                 { silent = true, noremap = true } },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<Leader>tt", "<cmd>NvimTreeToggle<CR>", { silent = true, desc = "NvimTreeToggle" } }
    },
    opts = {
      on_attach = tree_keys,
      filters = {
        git_ignored = true,
        dotfiles = false,
        custom = { "^.git$", "node_modules" },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = true,
  },
  {
    "folke/which-key.nvim",
    cmd = "WhichKey",
    config = true,
  },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "LspAttach",
    keys = {
      { "<Leader>e", "<cmd>TroubleToggle<CR>", desc = "Trouble" },
    },
    config = true,
  }
}
