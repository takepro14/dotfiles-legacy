return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", { silent = true, noremap = true } },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", { silent = true, noremap = true } },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", { silent = true, noremap = true } },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", { silent = true, noremap = true } },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local function open_selected_files(prompt_bufnr)
      local picker = action_state.get_current_picker(prompt_bufnr)
      local selections = picker:get_multi_selection()
      actions.close(prompt_bufnr)

      for _, entry in ipairs(selections) do
        -- Check based on path to work with both find_files and live_grep.
        if entry.path then
          vim.cmd("edit " .. entry.path)
          -- In find_files, entry.lnum is nil, but in live_grep, it is the line number of the search hit.
          if entry.lnum then
            vim.api.nvim_win_set_cursor(0, { entry.lnum, 0 })
          end
        end
      end
    end

    telescope.setup({
      telescope.load_extension("live_grep_args"),
      defaults = {
        mappings = {
          i = {
            -- Override telescope's default keymap (scroll down) to delete characters.
            ["<C-d>"] = function()
              vim.api.nvim_input("<DEL>")
            end,
            ["<C-o>"] = open_selected_files,
          },
        },
        layout_config = {
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        file_ignore_patterns = {
          ".git/",
          ".dropbox.cache/",
          "node_modules/",
          "tmp/",
        },
        preview = {
          -- Avoid slowdown during live grep in telescope.
          treesitter = false,
        },
        path_display = function(_, path)
          local tail = require("telescope.utils").path_tail(path)
          local dirname = path:match("(.*)/" .. tail) or "."
          return string.format("%s (%s)", tail, dirname)
        end,
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = true,
        },
      },
    })
  end,
}
