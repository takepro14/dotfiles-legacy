# ===================================
# Docker utilities
# ===================================

# --- Docker Commands ---
alias dp='docker ps'
alias di='docker images'

dsh() {
  docker run --rm -it $(docker images | fzf | awk "{print \$3}") sh
}

dat() {
  docker attach $(docker ps | fzf | awk "{print \$1}")
}

drm() {
  docker rm -vf $(docker ps -aq)
}

drmi() {
  docker rmi $(docker images -f "dangling=true" -q)
}

drmv() {
  docker volume rm $(docker volume ls -qf dangling=true)
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


