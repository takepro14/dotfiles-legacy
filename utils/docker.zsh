# ===================================
# Docker utilities
# ===================================

# --- Docker Commands ---
alias d='docker'
alias db='docker build'
alias dr='docker run'
alias dn='docker network'
alias dim='docker images'
alias din='docker inspect'
alias dpl='docker pull'
alias dps='docker ps'

dsh() {
  local image_id=$(docker images | fzf | awk "{print \$3}")
  [[ -n "$image_id" ]] && docker run --rm -it "$image_id" sh
}

dat() {
  local container_id=$(docker ps | fzf | awk "{print \$1}")
  [[ -n "$container_id" ]] && docker attach "$container_id"
}

dl() {
  local container_id=$(docker ps -a | fzf | awk "{print \$1}")
  [[ -n "$container_id" ]] && docker logs "$container_id"
}

drm() {
  local container_ids=$(docker ps -aq)
  [[ -n "$container_ids" ]] && docker rm -vf $container_ids
}

# ex. drmi | drmi auto
drmi() {
  if [[ "$1" == 'auto' ]]; then
    docker rmi $(docker images -f "dangling=true" -q)
  else
    images=$(
      docker images --format "{{.Repository}}:{{.Tag}} {{.CreatedSince}} {{.Size}} {{.ID}}" \
      | column -t \
      | fzf --multi --prompt="Remove image: "
    )
    [[ -n "$images" ]] && docker rmi $(echo "$images" | awk '{print $NF}' | xargs -r echo)
  fi
}

drmv() {
  local volumes=$(docker volume ls -qf dangling=true)
  [[ -n "$volumes" ]] && docker volume rm "$volumes"
}

dnginx() {
  read 'mode?Shell or Server [sh/sv]: '
  [[ "$mode" == "sh" ]] && docker run --rm -it nginx sh
  [[ "$mode" == "sv" ]] && docker run --rm -d -p 8080:80 nginx && open 'http://localhost:8080'
}

# --- Docker Compose Commands ---
alias dcb='docker compose build'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias run='docker compose run --rm app'


