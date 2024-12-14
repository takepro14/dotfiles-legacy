# ===================================
# Shell commands utilities
# ===================================

local UTILS_CONFIG_DIR=$HOME/.dotfiles/utils/config/

# --- File Operations  ---
alias ls='ls -G'
alias ll="ls -lG -D '%y-%m-%d %H:%M'"
alias la="ls -laG -D '%y-%m-%d %H:%M'"
alias -g C='| wc -l'
alias ...='../../'
alias ....='../../../'
alias .....='../../../../'

mkcd() {
  mkdir -p $1 && cd $_;
}

cdf() {
  local dir=$(find . -type d -not -path '*/.git*' | fzf --preview "ls -la {}")
  [[ -n "$dir" ]] && cd "$dir"
}

rmf() {
  local file=$(_selected_file)
  [[ -n "$file" ]] && rm "$file" && echo "$file is removed."
}

# --- Environment Management ---
alias load='set -a; source ./.env; set +a;'
alias paths="echo ${PATH} | tr ':' '\n'"

swsh() {
  echo "Current shell: $SHELL"
  cat /etc/shells | grep -vE '^\s*(#|$)' | fzf | xargs chsh -s
}

# --- Zsh Configuration ---
alias ze="nvim $HOME/.zshrc"
alias zr="source $HOME/.zshrc"

zc() {
  {
    echo "\n--- Config Files ---"; echo "ZDOTDIR: $ZDOTDIR\nZSH: $ZSH\n.zshrc: ${ZDOTDIR:-$HOME}/.zshrc"
    echo "\n--- Env Variables ---"; env
    echo "\n--- Options ---"; set -o
    echo "\n--- Key Bindings ---"; bindkey
    echo "\n--- Aliases ---"; alias
    echo "\n--- Functions ---"; functions | awk '/^[-_a-zA-Z0-9]+ \(\) \{$/ {print $1}'
  } | nvim -
}

# --- Git Commands ---
alias repo='cd $(ghq list -p | fzf)'
alias pullreq='gh pr view --web'
alias ghrepo='gh repo view --web'

# --- System Info & Process Management ---
alias sysinfo='neofetch'
alias monitor='htop -s PERCENT_CPU'

killp() {
  local cpu_col=3
  local pid=$(ps aux | sort -rk $cpu_col | fzf --header="$(ps aux | head -n 1)" | awk '{print $2}')
  [[ -n "$pid" ]] && kill -9 "$pid" && echo "Killed process $pid"
}

# --- Vim Commands ---
alias vim='nvim'
alias vimi='nvim -u ${HOME}/.dotfiles/config/nvim/init-minimal.lua'

vimf() {
  local file=$(_selected_file)
  [[ -n "$file" ]] && nvim "$file"
}

vimd() {
  local file1 file2
  file1=$(_selected_file 'File1: ') && echo "File 1: $file1" || return 1
  file2=$(_selected_file 'File2: ') && echo "File 2: $file2" || return 1
  nvim -d $file1 $file2
}

# --- Useful Tools ---
alias hatebu='open "https://b.hatena.ne.jp/hotentry/it"'

news() {
  keywords=('vim' 'cli' 'linux' 'ruby' 'golang' 'docker')
  selected=$(printf '%s\n' "${keywords[@]}" | fzf --prompt='Keywords: ')
  [[ -n "$selected" ]] && open "https://www.google.com/search?q=$(echo "$selected" | sed 's/ /+/g')&tbs=qdr:w"
}

openlinks() {
  local json_file="$UTILS_CONFIG_DIR/.local.links.json"
  [[ ! -f "$json_file" ]] && echo "Error: File '$json_file' not found." && return 1
  local browser=$(jq -r '.browser' "$json_file")
  local links=$(jq -r '.links | to_entries[] | "\(.key)\t\(.value)"' "$json_file")
  echo "$links" | while IFS=$'\t' read -r key url; do
    echo "Open: $key"
    open -a "$browser" "$url"
  done
}

sites() {
  local json_file="$UTILS_CONFIG_DIR/.local.sites.json" prompt_msg='Site: ' random=${1:+random}
  [[ -f "$json_file" ]] && _url_opener "$json_file" "$prompt_msg" "$random"
}

articles() {
  local json_file="$UTILS_CONFIG_DIR/.local.articles.json" prompt_msg='Articles: ' random=${1:+random}
  [[ -f "$json_file" ]] && _url_opener "$json_file" "$prompt_msg" "$random"
}

repcmd() {
  read 'cmd?Command: '; read 'interval?Interval (sec): '
  while true; do eval "$cmd"; sleep "$interval"; done;
}

fn() {
  local als=$(alias | awk -F'=' '{print $1}')
  local fns=$(declare -f | grep -Ev '^_|^git_|^prompt_' | grep '^[a-zA-Z_][a-zA-Z0-9_]* ()' | awk '{print $1}')
  local selection=$(printf "%s\n%s" "$als" "$fns" | fzf --prompt="Alias or Function: ")
  [[ -n "$selection" ]] && print -z "$selection"
}

ggl() {
  open "https://google.co.jp/search?q=$(printf "%s+" "$@")"
}

# --- Generators ---
uuid() {
  uuidgen | tr \[:upper:\] \[:lower:\]
}

keygen() {
  read 'length?Length (default: 12): '; local length=${length:-12}
  openssl rand -base64 "$length" | tee >(pbcopy) && echo 'Copied!'
}

b64() {
  read 'string?String: '; read 'mode?Encode or Decode? (e/d): '
  echo "$string" | base64 $([[ $mode =~ ^[Dd]$ ]] && echo "-d") | tee >(pbcopy) && echo 'Copied!'
}

# --- Network Utilities ---
gip() {
  curl -s http://checkip.amazonaws.com
}

ipv4() {
  ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -Eo "([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1"
}

# --- Private functions ---

_url_opener() {
  local json_file="$1" prompt_msg="$2" random=${3:+random}
  if [[ -n "$random" ]]; then
    local target=$(jq -r '.[] | "\(.url)"' "$json_file" | shuf -n 1)
    [[ -n "$target" ]] && open "$target"
  else
    local target=$(
    jq -r 'sort_by(.tag) | .[] | "\(.tag)\t\(.title)\t\(.url)\t\(.comment)"' "$json_file" | \
      fzf --preview="printf 'Tag: %s\nTitle: %s\nURL: %s\nComment: %s\n' {1} {2} {3} {4}" \
          --preview-window=up:4 --delimiter=$'\t' --prompt="$prompt_msg"
    )
    [[ -n "$target" ]] && open "$(echo "$target" | awk -F'\t' '{print $3}')"
  fi
}

_selected_file() {
  local prompt_arg=()
  [[ -n "$1" ]] && prompt_arg=(--prompt "$1")
  fzf "${prompt_arg[@]}" --preview 'bat --theme=Dracula --style=numbers --color=always {}'
}

