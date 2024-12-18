local ls = require('luasnip')

local codes = {
  ['shebang'] = {
    '#!/bin/sh -eu',
  },
  ['docker nodejs run'] = {
    'docker run -it --rm \\',
    '  -e HOME=/usr/src/app \\',
    '  -v $(pwd):/usr/src/app \\',
    '  -w /usr/src/app \\',
    '  node:21.7 index.js',
  },
  ['docker nodejs bash'] = {
    'docker run -it --rm \\',
    '  -e HOME=/usr/src/app \\',
    '  -v $(pwd):/usr/src/app \\',
    '  -w /usr/src/app \\',
    '  node:21.7 /bin/bash',
  },
  ['docker nodejs stdin'] = {
    'docker run -it --rm \\',
    '  -e HOME=/usr/src/app \\',
    '  -v $(pwd):/usr/src/app \\',
    '  -w /usr/src/app \\',
    '  --entrypoint /bin/bash \\',
    '  node:21.7 \\',
    '    -c "npm install && \\',
    '        npm list"',
  },
  ['docker puppeteer'] = {
    'docker run -i --init --cap-add=SYS_ADMIN --rm \\',
    '  -e PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable \\',
    '  -v $(pwd):/home/pptruser \\',
    '  -w /home/pptruser \\',
    '  --platform linux/amd64 \\',
    '  ghcr.io/puppeteer/puppeteer:22 /bin/bash \\',
    '    -c "npm install && \\',
    '        npm start"',
  },
  ['docker ruby'] = {
    'docker run -it --rm \\',
    '  -e HOME=/usr/src/app \\',
    '  -v $(pwd):/usr/src/app \\',
    '  -w /usr/src/app \\',
    '  ruby:3.2 ruby script.rb',
  },
  ['docker python'] = {
    'docker run -it --rm \\',
    '  -e HOME=/usr/src/app \\',
    '  -v $(pwd):/usr/src/app \\',
    '  -w /usr/src/app \\',
    '  python:3.9 python main.py',
  },
  ['docker terraform'] = {
    'docker run --rm -it \\',
    '  -e GOOGLE_APPLICATION_CREDENTIALS=/tmp/secrets/key.json \\',
    '  -v $GOOGLE_APPLICATION_CREDENTIALS:/tmp/secrets/key.json:ro \\',
    '  -v $(pwd):/usr/src/app \\',
    '  -w /usr/src/app \\',
    '  --entrypoint /bin/sh \\',
    '  hashicorp/terraform:1.8 \\',
    '    -c "terraform -version"',
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
