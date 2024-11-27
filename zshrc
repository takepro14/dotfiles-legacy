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
export LANG=en_US.UTF-8
export EDITOR=nvim
export XDG_CONFIG_HOME=~/.config
export PURE_PROMPT_SYMBOL="$"
export FZF_DEFAULT_OPTS='--height 50% --reverse'
setopt auto_cd
setopt auto_pushd
setopt nobeep
setopt complete_aliases
setopt physical
alias g='git'
alias ls='ls -G'
alias ll="ls -lG -D '%y-%m-%d %H:%M'"
alias la="ls -laG -D '%y-%m-%d %H:%M'"
alias load='set -a; source ./.env; set +a;'
alias zedit="nvim $HOME/.zshrc"
alias zreload="source $HOME/.zshrc"
alias repo='cd $(ghq list -p | fzf)'
alias pullreq='gh pr view --web'
alias ghrepo='gh repo view --web'
alias paths="echo ${PATH} | tr ':' '\n'"
alias monitor='htop -s PERCENT_CPU'
alias -g C='| wc -l'
alias ...='../../'
alias ....='../../../'
alias .....='../../../../'
alias sysinfo='neofetch'

fzcd() {
  dir=$(find . -type d -not -path '*/.git*' | fzf --preview "ls -la {}")
  [ -n "$dir" ] && cd "$dir"
}

fzrm() {
  fzf --preview "cat {}" | xargs -r -I{} sh -c 'rm "{}" && echo "{} is removed."'
}

fzvim() {
  fzf --preview "cat {}" | xargs -r nvim
}

mkcd() {
  mkdir -p $1 && cd $_;
}

uuid() {
  uuidgen | tr \[:upper:\] \[:lower:\]
}

keygen() {
  openssl rand -base64 ${1:-12} | pbcopy && echo 'Copied!'
}

gip() {
  curl -s http://checkip.amazonaws.com
}

ipv4() {
  ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -Eo "([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1"
}

swsh() {
  echo "Current shell: $SHELL"
  cat /etc/shells | grep -vE '^\s*(#|$)' | fzf | xargs chsh -s
}

vimdiff() {
  local file1 file2
  file1=$(fzf --prompt="first file: " --preview="cat {}") || return 1
  echo "first file: $file1"
  file2=$(fzf --prompt="second file: " --preview="cat {}") || return 1
  nvim -d $file1 $file2
}

til() {
  find ~/ghq/github.com/takepro14/til \( -type d -name node_modules -o -type d -name .git \) -prune -o -type f | sort | fzf --height 80% | xargs -I {} code "{}"
}

tilnew() {
  read -r "tech?Enter the tech: "
  read "title?Enter the title: "
  code "$HOME/ghq/github.com/takepro14/til/[${tech}] ${title}.md"
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
alias vimi='nvim -u ${HOME}/.dotfiles/config/nvim/init-minimal.lua'

# tmux
source $HOME/.dotfiles/zsh/tmux.zsh

# Git
eval "$(hub alias -s)"

# Docker
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

eval "$(rbenv init - zsh)"

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
  ~/cloud_sql_proxy -instances=$INSTANCE_CONNECTION_NAME=tcp:3306 \
                    -credential_file=$GOOGLE_APPLICATION_CREDENTIALS
}

# acc
source $HOME/.dotfiles/zsh/acc.zsh

# Salesforce
source $HOME/.dotfiles/zsh/salesforce.zsh

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
