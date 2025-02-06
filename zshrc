# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

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

# Zsh generic
export LANG=en_US.UTF-8
export EDITOR=nvim
export XDG_CONFIG_HOME=~/.config
export PURE_PROMPT_SYMBOL="$"
export FZF_DEFAULT_OPTS='--height 85% --reverse'
setopt auto_cd
setopt auto_pushd
setopt nobeep
setopt complete_aliases
setopt physical
alias ls='ls -G'
alias ll="ls -lG -D '%y-%m-%d %H:%M'"
alias la="ls -laG -D '%y-%m-%d %H:%M'"
alias -g C='| wc -l'
alias ...='../../'
alias ....='../../../'
alias .....='../../../../'
alias ze="nvim $HOME/.zshrc"
alias zr="source $HOME/.zshrc"

# Zsh history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_find_no_dups
setopt hist_reduce_blanks
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history
bindkey -e  # enable emacs style key bind

# Memo
note() {
  local dir="$HOME/Dropbox/tech"
  local selected_file() {
    find "$dir" -type f | sort | sed "s|^$dir/||" |\
      fzf --preview "bat --theme=Dracula --style=numbers --color=always $dir/{}"
  }
  case "$1" in
    new)
      read 'tech?Tech: '
      read 'title?Title: '
      local file="$dir/[$tech] $title.md"
      touch "$file" && nvim "$file"
      ;;
    rm)
      local file=$(selected_file)
      [[ -n "$file" ]] && rm "$dir/$file" && echo "$file is removed."
      ;;
    "")
      local file=$(selected_file)
      [[ -n "$file" ]] && nvim "$dir/$file"
      ;;
    *)
      echo 'Usage: note [c|s|d]' && return 1
      ;;
  esac
}

# Tmux
alias tmls='tmux ls'
alias tmk='tmux kill-server'
alias tma='tmux attach'

tmux!() {
  tmux kill-server 2>/dev/null
  local config="$HOME/Dropbox/config/tmux.json"
  local name=$(jq -r '.name' "$config")
  local windows=($(jq -c '.windows[]' "$config" | sed "s|\$HOME|$HOME|g"))
  tmux new-session -d -s "$name" \
    -n $(echo "${windows[1]}" | jq -r '.title') \
    -c $(echo "${windows[1]}" | jq -r '.path')
  for window in "${windows[@]:1}"; do
    tmux new-window -t "$name" \
      -n $(echo "$window" | jq -r '.title') \
      -c $(echo "$window" | jq -r '.path')
  done
  tmux select-window -t "$name:1"
  tmux attach-session -t "$name"
}

ide() {
  tmux split-window -v
  tmux resize-pane -D 10
  tmux split-window -h
  tmux select-pane -t 0
  nvim
}

# Neovim
alias vim="nvim"

# Git
alias g='git'
alias gst='git status'
alias gcm='git commit'
alias gp='git push'
alias gl='git log'
alias gbr='git branch'
alias gco='git branch | fzf | xargs git switch'
alias grmb='git branch | fzf | xargs git branch -D'
alias repo='cd $(ghq list -p | fzf)'

# Docker
colima status > /dev/null 2>&1 || colima start
alias -g DI='docker images | fzf | awk "{print \$3}"'
alias -g DC='docker ps | fzf | awk "{print \$1}"'
alias d='docker'
alias di='docker images'
alias dp='docker ps'
alias dsh='docker run --rm -it $(DI) sh'
alias dat='docker attach $(DC)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -f "dangling=true" -q)'
alias drmv='docker volume rm $(docker volume ls -qf dangling=true)'
alias build='docker compose build'
alias up='docker compose up'
alias down='docker compose down'
alias restart='docker compose restart'
alias run='docker compose run --rm'

# Kubernetes
source <(kubectl completion zsh)
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
alias -g KP='$(kubectl get pods | fzf | awk "{print \$1}")'
alias -g KN='$(kubectl get nodes | fzf | awk "{print \$1}")'
alias kc='kubectl'
alias kce='kubectl exec -it KP' # ex. kce -c app ash
alias kcl='kubectl logs -f KP'  # ex. kcl app
alias kdp='kubectl describe pod KP'
alias kdn='kubectl describe node KN'

gauth() {
  export GOOGLE_APPLICATION_CREDENTIALS=$(find ~/.gcloud/*.json -type f | fzf)
  export GOOGLE_PROJECT_ID=$(cat $GOOGLE_APPLICATION_CREDENTIALS | jq -r '.project_id')
  gcloud auth activate-service-account \
      --key-file=$GOOGLE_APPLICATION_CREDENTIALS \
      --project=$GOOGLE_PROJECT_ID > /dev/null 2>&1
  _kctx
  _gcfg
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

_kctx() {
  kubectl config unset current-context > /dev/null 2>&1
  export REGION_NAME=asia-northeast1
  export CLUSTER_NAME=$(gcloud container clusters list --format 'value(name)' --limit 1 2>/dev/null)
  if [ ! -z $CLUSTER_NAME ]; then
    gcloud container clusters get-credentials \
      --region $REGION_NAME $CLUSTER_NAME > /dev/null 2>&1
  fi
}

_gcfg() {
  echo -e "project: $(gcloud config get-value project)"
  if [ ! -z $CLUSTER_NAME ]; then
    echo -e "context: $(kubectl config current-context)"
  else
    echo -e "context: "
  fi
}

# Google Cloud Platform
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"

# Ruby
alias rubocop="docker compose run --rm app bundle exec rubocop -a"
alias routes="docker compose run --rm app bin/rake routes"
alias rspec='docker compose run --rm -e "RAILS_ENV=test" app bundle exec rspec'
alias console="docker compose run --rm app bin/rails c"
alias dbconsole="docker compose run --rm app bin/rails dbconsole"
alias ridgepole="docker compose run --rm app bin/rake ridgepole:apply"
alias ridgepolet='docker compose run --rm -e "RAILS_ENV=test" app bin/rake ridgepole:apply'

# Node.js
alias ns="npm ls -g --depth=0"

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
