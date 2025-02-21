local ls = require('luasnip')

return {
  ls.snippet('print', {
    ls.text_node('print("'),
    ls.insert_node(1, 'Hello, World!'),
    ls.text_node('")'),
  }),
  ls.snippet('func', {
    ls.text_node('local function '),
    ls.insert_node(1, 'function_name'),
    ls.text_node('('),
    ls.insert_node(2, 'args'),
    ls.text_node(')\n  '),
    ls.insert_node(0),
    ls.text_node('\nend'),
  }),
}
