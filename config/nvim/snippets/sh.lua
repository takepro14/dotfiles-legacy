local ls = require('luasnip')

ls.add_snippets('sh', {
  ls.snippet('docker', {
    ls.text_node({
      'docker run -it --rm ',
      '  -e HOME=/usr/src/app ',
      '  -v $(pwd):/usr/src/app ',
      '  -w /usr/src/app ',
      '  ruby:3.2 ruby script.rb',
    }),
  }),
})
