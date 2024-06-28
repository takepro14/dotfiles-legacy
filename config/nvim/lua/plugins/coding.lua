return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          "bash",
          "c",
          "css",
          "dockerfile",
          "git_config",
          "gitcommit",
          "gitignore",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "python",
          "query",
          "rbs",
          "ruby",
          "rust",
          "scala",
          "scss",
          "sql",
          "terraform",
          "tmux",
          "typescript",
          "vim",
          "vimdoc",
          "vue",
          "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true },
      }
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = {
      'nvim-lua/plenary.nvim',
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0"
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", {} },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",  {} },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",    {} },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",  {} }
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        telescope.load_extension("live_grep_args"),
        defaults = {
          file_ignore_patterns = {
            ".git/",
            "node_modules/"
          }
        },
        pickers = {
          find_files = {
            hidden = true
          }
        }
      })
    end
  },
  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        window = {
          completion = cmp.config.window.bordered({
            completeopt = "menu,menuone,preview",
            border = "rounded",
            winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
          }),
        },
        formatting = {
          format = require("lspkind").cmp_format({
            preset = "codicons",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
        mapping = {
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "path" },
          { name = "dictionary", keyword_length = 2 },
        },
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      cmp.event:on("confirm_done", function()
        require("nvim-autopairs.completion.cmp").on_confirm_done()
      end)
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "LspAttach",
    config = function()
      require("lint").linters_by_ft = {
        ["*"] = { "codespell" },
        c = { "clangtidy" },
        python = { "ruff", "mypy", "pylint" },
        -- javascript = { "eslint" },
        css = { "stylelint" },
        cmake = { "cmakelint" },
        markdown = { "markdownlint" },
        sh = { "shellcheck" },
        zsh = { "zsh" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "autoflake", { "black", "ruff_format" } },
        javascript = { { "biome-check", "prettier", "deno_fmt" } },
        c = { "clang_format" },
        cpp = { "clang_format" },
        cmake = { "cmake_format" },
        rust = { "rustfmt" },
        go = { "gofmt", "goimports" },
        swift = { "swift_format" },
        sql = { "sql_formatter" },
        zig = { "zigfmt" },
        json = { { "jq", "jsonnetfmt" } },
        yaml = { "yamlfmt" },
        toml = { "taplo" },
        ["_"] = { "trim_whitespace", "trim_newlines" },
      },
      formatters = {
        deno_fmt = {
          cwd = function()
            require("conform.util").root_file({ "deno.json" })
          end,
        },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = "UIEnter",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    opts = {
      enable_autocmd = false,
      toggler = { line = "<Leader>/" },  -- for single line
      opleader = { line = "<Leader>/" }, -- for multiple lines
      extra = { eol = "<Leader>a" },
      pre_hook = function()
        require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
      end,
    },
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },
  {
    "max397574/better-escape.nvim",
    opts = {
      mapping = { "kj", "jj" },
    },
  },
  {
    "uga-rosa/cmp-dictionary",
    event = "InsertEnter",
    opts = {
      paths = { "/usr/share/dict/words" },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    config = true,
    event = "InsertEnter",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = { enable_autocmd = false },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "CursorMoved",
  },
}
