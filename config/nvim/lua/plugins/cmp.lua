return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "onsails/lspkind.nvim",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },
  event = { "InsertEnter", "CmdlineEnter" },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
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
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.abort(),
        -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if luasnip.expandable() then
              luasnip.expand()
            else
              cmp.confirm({
                select = true,
              })
            end
          else
            fallback()
          end
        end),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
      sources = {
        { name = "luasnip" },
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
}
