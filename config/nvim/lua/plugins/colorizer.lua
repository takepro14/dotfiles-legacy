return {
  'norcalli/nvim-colorizer.lua',
  lazy = true,
  event = 'BufRead',
  config = function()
    local colorizer = require('colorizer')
    colorizer.setup({ '*' }, {
      RGB = true,      -- #RGB hex codes
      RRGGBB = true,   -- #RRGGBB hex codes
      names = true,    -- "Name" codes like Blue or blue
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      rgb_fn = true,   -- CSS rgb() and rgba() functions
      hsl_fn = true,   -- CSS hsl() and hsla() functions
      css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
    })
    colorizer.setup({ '*' }, {
      -- To avoid slowdown during live grep in telescope
      excluded = { 'TelescopePreview' },
    })
  end,
}
