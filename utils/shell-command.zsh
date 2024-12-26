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
  local files=$(_selected_files)
  local file_count=$(echo "$files" | wc -l | awk '{print $1}')
  [[ -n "$file" ]] && rm $(echo "$files") && echo "$file_count files is removed."
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
alias g='git'
alias repo='cd $(ghq list -p | fzf)'
alias pullreq='gh pr view --web'

# ex. ghrepo | ghrepo create | ghrepo clone
ghrepo() {
  if [[ -z "$1" ]]; then
    gh repo view --web
  elif [[ "$1" == "create" ]]; then
    local repo_name=$(basename "$(pwd)")
    gh repo create "$repo_name" --private --source=. --push
  elif [[ "$1" == "clone" ]]; then
    local username=$(git config --global user.name)
    local reponame=$(gh repo list "$username" | fzf | awk '{print $1}')
    [[ -n "$reponame" ]] && ghq get "$reponame"
  fi
}

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

vimperf() {
  local filename=$(date +"startuptime_%Y-%m-%d_%H:%M:%S.log")
  vim --startuptime "$filename" +q
  nvim "$filename"
}

# --- Useful Tools ---
alias hatebu='open "https://b.hatena.ne.jp/hotentry/it"'

news() {
  local keywords=('vim' 'cli' 'linux' 'ruby' 'golang' 'docker')
  for keyword in "${keywords[@]}"; do
    open "https://google.co.jp/search?q=${keyword}&tbs=qdr:w"
  done
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

# ex. urls | urls 1
urls() {
  local json_file="$UTILS_CONFIG_DIR/.local.urls.json" random=${1:+random}
  [[ ! -f "$json_file" ]] && return 1

  if [[ -n "$random" ]]; then
    local target=$(jq -r '.[] | "\(.url)"' "$json_file" | shuf -n 1)
    [[ -n "$target" ]] && open "$target"
  else
    local targets=(); while IFS= read -r line; do
      targets+=("$line")
    done < <(
    jq -r 'sort_by([.tag, .kind]) | .[] | "\(.tag)\t\(.kind)\t\(.title)\t\(.url)\t\(.comment)\t"' "$json_file" | \
        fzf --multi --preview="printf 'Tag: %s\nKind: %s\nTitle: %s\nURL: %s\nComment: %s\n' {1} {2} {3} {4} {5}" \
            --preview-window=up:5 --delimiter=$'\t' --prompt='Url: '
    )
    [[ ${#targets[@]} -eq 0 ]] && return 1
    for target in "${targets[@]}"; do
      url=$(echo "$target" | awk -F'\t' '{print $4}')
      open "$url"
    done
  fi
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

_selected_file() {
  local prompt_arg=()
  [[ -n "$1" ]] && prompt_arg=(--prompt "$1")
  fzf "${prompt_arg[@]}" --preview 'bat --theme=Dracula --style=numbers --color=always {}'
}

_selected_files() {
  local prompt_arg=()
  [[ -n "$1" ]] && prompt_arg=(--prompt "$1")
  fzf "${prompt_arg[@]}" --multi --preview 'bat --theme=Dracula --style=numbers --color=always {}'
}

