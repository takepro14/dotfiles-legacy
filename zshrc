# Zplug
source ~/.zplug/init.zsh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
zplug load

# zsh generic config
export GOOGLE_APPLICATION_CREDENTIALS=~/.ssh/xxxxxx.json
export LANG=ja_JP.UTF-8
export EDITOR=nvim
export XDG_CONFIG_HOME=~/.config
export PURE_PROMPT_SYMBOL="$" # pure theme
export FZF_DEFAULT_OPTS='--height 20% --reverse'
setopt auto_cd
setopt auto_pushd
setopt nobeep
setopt complete_aliases
alias ll='ls -lG'
alias la='ls -laG'
alias load='set -a; source ./.env; set +a;'
alias reload='source ~/.zshrc'
alias repo='cd $(ghq list -p | fzf)'
alias pullreq='gh pr view --web'
alias repository='gh repo view --web'
alias -g C='| wc -l'
alias paths="echo ${PATH} | tr ':' '\n'"

mkcd() {
  mkdir -p $1 && cd $_;
}

uuid() {
  uuidgen | tr \[:upper:\] \[:lower:\]
}

keygen() {
  local length=${1:-12}
  echo "$(openssl rand -base64 $length)"
}

gip() {
  curl -s http://checkip.amazonaws.com
}

ipv4() {
  ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -Eo "([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1"
}

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
g() {
  local url='https://google.co.jp/search?q='
  url+=$(printf "%s+" "$@")
  chrome "${url%+}"
}

# zsh history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_find_no_dups
setopt hist_reduce_blanks
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey -e  # enable emacs style key bind

# Neovim
alias vim='nvim'

# Git
eval "$(hub alias -s)"

# Docker
alias -g DI='docker images | fzf | awk "{print \$3}"'
alias -g DC='docker ps | fzf | awk "{print \$1}"'
alias dsh='docker run --rm -it $(DI) sh'
alias dat='docker attach $(DC)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -f "dangling=true" -q)'
alias drmv='docker volume rm $(docker volume ls -qf dangling=true)'
alias build='docker-compose build --no-cache'
alias up='docker-compose up'
alias down='docker-compose down'
alias restart='docker-compose restart'

# Kubernetes
alias -g KP='$(kubectl get pods | fzf | awk "{print \$1}")'
alias -g KN='$(kubectl get nodes | fzf | awk "{print \$1}")'
alias kc='kubectl'
alias kce='kubectl exec -it KP' # ex. kce -c app ash
alias kcl='kubectl logs -f KP'  # ex. kcl app
alias kdp='kubectl describe pod KP'
alias kdn='kubectl describe node KN'
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Golang
export GOPATH=$HOME/go

# Ruby
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

# Node.js
alias ns="npm ls -g --depth=0"
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"


# Google Cloud Platform
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"

# Kubernetes
source <(kubectl completion zsh)
complete -F __start_kubectl kc

kctx() {
  kubectl config unset current-context > /dev/null 2>&1
  export REGION_NAME=asia-northeast1
  export CLUSTER_NAME=$(gcloud container clusters list --format 'value(name)' --limit 1 2>/dev/null)
  if [ ! -z $CLUSTER_NAME ]; then
    gcloud container clusters get-credentials \
      --region $REGION_NAME $CLUSTER_NAME > /dev/null 2>&1
  fi
}

gcfg() {
  echo -e "project: $(gcloud config get-value project)"
  if [ ! -z $CLUSTER_NAME ]; then
    echo -e "context: $(kubectl config current-context)"
  else
    echo -e "context: "
  fi
}

gauth() {
  export GOOGLE_APPLICATION_CREDENTIALS=$(find ~/.gcloud/*.json -type f | fzf)
  export GOOGLE_PROJECT_ID=$(cat $GOOGLE_APPLICATION_CREDENTIALS | jq -r '.project_id')
  gcloud auth activate-service-account \
      --key-file=$GOOGLE_APPLICATION_CREDENTIALS \
      --project=$GOOGLE_PROJECT_ID > /dev/null 2>&1
  kctx
  gcfg
  gcloud auth print-access-token
}

proxy() {
  INSTANCE_CONNECTION_NAME=`
    gcloud sql instances list --format 'value(name)' \
      | fzf \
      | xargs gcloud sql instances describe --format 'value(connectionName)'
  `
}

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
