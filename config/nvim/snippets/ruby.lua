local ls = require('luasnip')

local codes = {
  ['fro'] = {
    '# frozen_string_literal: true',
  },
}

local snippets = {}

for trigger, lines in pairs(codes) do
  table.insert(
    snippets,
    ls.snippet(trigger, {
      ls.text_node(lines),
    })
  )
end

return snippets
