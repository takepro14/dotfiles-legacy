local ls = require('luasnip')

local codes = {
  ['!'] = {
    '<!doctype html>',
    '<html lang="en">',
    '',
    '<head>',
    '  <meta charset="UTF-8" />',
    '  <meta name="viewport" content="width=device-width, initial-scale=1.0" />',
    '  <title>Document</title>',
    '</head>',
    '',
    '<body></body>',
    '',
    '</html>',
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
