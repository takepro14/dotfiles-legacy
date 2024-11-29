# Docker utilities

alias -g DI='docker images | fzf | awk "{print \$3}"'
alias -g DC='docker ps | fzf | awk "{print \$1}"'
alias dsh='docker run --rm -it $(DI) sh'
alias dat='docker attach $(DC)'
alias drm='docker rm -vf $(docker ps -aq)'
alias drmi='docker rmi $(docker images -f "dangling=true" -q)'
alias drmv='docker volume rm $(docker volume ls -qf dangling=true)'
alias dcbuild='docker-compose build --no-cache'
alias dcup='docker-compose up'
alias dcdown='docker-compose down'
alias dcrestart='docker-compose restart'
