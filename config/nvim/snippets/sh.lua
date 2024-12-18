local ls = require('luasnip')

ls.add_snippets('sh', {
  ls.snippet('shebang', {
    ls.text_node({ '#!/bin/sh -eu' }),
  }),

  -- https://github.com/otaaaa/docker-boilerplate
  ls.snippet('docker nodejs run', {
    ls.text_node({
      'docker run -it --rm \\',
      '  -e HOME=/usr/src/app \\',
      '  -v $(pwd):/usr/src/app \\',
      '  -w /usr/src/app \\',
      '  node:21.7 index.js',
    }),
  }),

  ls.snippet('docker nodejs bash', {
    ls.text_node({
      'docker run -it --rm \\',
      '  -e HOME=/usr/src/app \\',
      '  -v $(pwd):/usr/src/app \\',
      '  -w /usr/src/app \\',
      '  node:21.7 /bin/bash',
    }),
  }),

  ls.snippet('docker nodejs stdin', {
    ls.text_node({
      'docker run -it --rm \\',
      '  -e HOME=/usr/src/app \\',
      '  -v $(pwd):/usr/src/app \\',
      '  -w /usr/src/app \\',
      '  --entrypoint /bin/bash \\',
      '  node:21.7 \\',
      '    -c "npm install && \\',
      '        npm list"',
    }),
  }),

  ls.snippet('docker puppeteer', {
    ls.text_node({
      'docker run -i --init --cap-add=SYS_ADMIN --rm \\',
      '  -e PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable \\',
      '  -v $(pwd):/home/pptruser \\',
      '  -w /home/pptruser \\',
      '  --platform linux/amd64 \\',
      '  ghcr.io/puppeteer/puppeteer:22 /bin/bash \\',
      '    -c "npm install && \\',
      '        npm start"',
    }),
  }),

  ls.snippet('docker ruby', {
    ls.text_node({
      'docker run -it --rm \\',
      '  -e HOME=/usr/src/app \\',
      '  -v $(pwd):/usr/src/app \\',
      '  -w /usr/src/app \\',
      '  ruby:3.2 ruby script.rb',
    }),
  }),

  ls.snippet('docker python', {
    ls.text_node({
      'docker run -it --rm \\',
      '  -e HOME=/usr/src/app \\',
      '  -v $(pwd):/usr/src/app \\',
      '  -w /usr/src/app \\',
      '  python:3.9 python main.py',
    }),
  }),

  ls.snippet('docker terraform', {
    ls.text_node({
      'docker run --rm -it \\',
      '  -e GOOGLE_APPLICATION_CREDENTIALS=/tmp/secrets/key.json \\',
      '  -v $GOOGLE_APPLICATION_CREDENTIALS:/tmp/secrets/key.json:ro \\',
      '  -v $(pwd):/usr/src/app \\',
      '  -w /usr/src/app \\',
      '  --entrypoint /bin/sh \\',
      '  hashicorp/terraform:1.8 \\',
      '    -c "terraform -version"',
    }),
  }),
})
