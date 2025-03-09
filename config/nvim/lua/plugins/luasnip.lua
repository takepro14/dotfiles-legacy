return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local ls = require("luasnip")

    ls.config.set_config({
      history = true, -- 展開履歴の保存
      updateevents = "TextChanged,TextChangedI", -- 自動更新を有効化
      enable_autosnippets = true, -- 自動スニペットを有効化
    })

    require("luasnip.loaders.from_lua").lazy_load({
      paths = vim.fn.expand("$HOME/.dotfiles/config/nvim/snippets"),
    })
  end,
}
