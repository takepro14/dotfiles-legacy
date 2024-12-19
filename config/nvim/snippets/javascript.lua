local ls = require('luasnip')

local codes = {
  ['for'] = {
    'for (let i = 0; i < array.length; i++) {',
    '  console.log(array[i]);',
    '}',
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
