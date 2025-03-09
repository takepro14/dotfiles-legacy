local ls = require("luasnip")

local codes = {
  ["shebang"] = {
    "#!/bin/sh -eu",
  },
  ["for"] = {
    'for item in "${items[@]}"; do',
    '  echo "Hello, ${item}!!"',
    "done",
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
