# Ruby utilities

rubocop() {
  docker compose run --rm app bundle exec rubocop -a
}

routes() {
  docker compose run --rm app bin/rake routes
}

rspec() {
  docker compose run --rm -e "RAILS_ENV=test" app bundle exec rspec
}

console() {
  if [[ "$1" == 't' ]]; then
    docker compose run --rm -e "RAILS_ENV=test" app bin/rails c
  else
    docker compose run --rm app bin/rails c
  fi
}

dbconsole() {
  docker compose run --rm app bin/rails dbconsole
}

ridgepole() {
  if [[ "$1" == 't' ]]; then
    docker compose run --rm -e "RAILS_ENV=test" app bin/rake ridgepole:apply
  else
    docker compose run --rm app bin/rake ridgepole:apply
  fi
}

cleanup() {
  rm -f tmp/pids/server.pid && \
  docker container prune -f && \
  docker volume rm $(docker volume ls -q -f name=redis-data | fzf)
}
