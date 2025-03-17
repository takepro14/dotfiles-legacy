alias d='docker'
alias db='docker build'
alias dr='docker run'
alias dn='docker network'
alias di='docker images'
alias dp='docker ps'

dsh() {
  local image_id=$(docker images | fzf | awk '{print $3}')
  [[ -n "$image_id" ]] && docker run --rm -it "$image_id" sh
}

dat() {
  local container_id=$(docker ps | fzf | awk '{print $1}')
  [[ -n "$container_id" ]] && docker attach "$container_id"
}

# ex. drm | drm auto
drm() {
  if [[ -z "$1" ]]; then
    local containers=$(
      docker ps -a --format "{{.Names}}({{.Image}}) {{.Status}} {{.ID}}" |
        column -t |
        fzf --multi --prompt="Remove containers: "
    )
    [[ -n "$containers" ]] && docker rm -vf $(echo "$containers" | awk '{print $NF}' | xargs -r echo)
  elif [[ "$1" == 'auto' ]]; then
    local container_ids=$(docker ps -aq)
    [[ -n "$container_ids" ]] && docker rm -vf "$container_ids"
  else
    docker rm "$@"
  fi
}

# ex. drmi | drmi auto
drmi() {
  if [[ -z "$1" ]]; then
    local images=$(
      docker images --format "{{.Repository}}:{{.Tag}} {{.CreatedSince}} {{.Size}} {{.ID}}" |
        column -t |
        fzf --multi --prompt="Remove image: "
    )
    [[ -n "$images" ]] && docker rmi $(echo "$images" | awk '{print $NF}' | xargs -r echo)
  elif [[ "$1" == 'auto' ]]; then
    local images=$(docker images -f "dangling=true" -q)
    [[ -n "$images" ]] && docker rmi "$images"
  else
    docker rmi "$@"
  fi
}

drmv() {
  local volumes=$(docker volume ls -qf dangling=true)
  [[ -n "$volumes" ]] && docker volume rm "$volumes"
}

build() {
  docker compose build "$@"
}

up() {
  docker compose up "$@"
}

down() {
  docker compose down "$@"
}

restart() {
  docker compose restart "$@"
}

run() {
  docker compose run --rm "$@"
}
