# Ruby utilities

alias rubocop='docker compose run --rm app bundle exec rubocop -a'
alias rspec='docker compose run --rm -e "RAILS_ENV=test" app bundle exec rspec'
alias console='docker compose run --rm app bin/rails c'
alias consolet='docker compose run --rm -e "RAILS_ENV=test" app bin/rails c'
alias dbconsole='docker compose run --rm app bin/rails dbconsole'
alias routes='docker compose run --rm app bin/rake routes'
alias ridgepole='docker compose run --rm app bin/rake ridgepole:apply'
alias ridgepolet='docker compose run --rm -e "RAILS_ENV=test" app bin/rake ridgepole:apply'
alias run='docker compose run --rm app'

cleanup() {
  rm -f tmp/pids/server.pid && \
  docker container prune -f && \
  docker volume rm $(docker volume ls -q -f name=redis-data | fzf)
}
