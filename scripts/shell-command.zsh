# ===================================
# Shell commands utilities
# ===================================

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

cd2() {
  local dir=$(find . -type d -not -path '*/.git*' | fzf --preview "ls -la {}")
  [[ -n "$dir" ]] && cd "$dir"
}

rm() {
  if [[ "$1" == 'find' ]]; then
    local files=$(_selected_files)
    local file_count=$(echo "$files" | wc -l | awk '{print $1}')
    [[ -n "$files" ]] && rm $(echo "$files") && echo "$file_count files is removed."
  else
    # Avoid recursive call
    command rm "$@"
  fi
}

# --- Environment Management ---
load() {
  set -a
  source ./.env;
  set +a;
}

paths() {
  echo ${PATH} | tr ':' '\n'
}

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

# --- Vim Commands ---
vim() {
  case "$1" in
    help)
      echo "Usage: vim [change|diff|perf|find|mini|<file>]"
      ;;
    change)
      nvim $(git ls-files --others --exclude-standard && git diff --name-only)
      ;;
    diff)
      local file1 file2
      file1=$(_selected_file 'File1: ') && echo "File 1: $file1" || return 1
      file2=$(_selected_file 'File2: ') && echo "File 2: $file2" || return 1
      nvim -d "$file1" "$file2"
      ;;
    perf)
      local filename=$(date +"startuptime_%Y-%m-%d_%H:%M:%S.log")
      vim --startuptime "$filename" +q
      nvim "$filename"
      ;;
    find)
      local file=$(_selected_file)
      [[ -n "$file" ]] && nvim "$file"
      ;;
    mini)
      nvim -u "${HOME}/.dotfiles/config/nvim/init-minimal.lua"
      ;;
    *)
      nvim "$@"
      ;;
  esac
}

# --- Useful Tools ---
repcmd() {
  read 'cmd?Command: '; read 'interval?Interval (sec): '
  while true; do eval "$cmd"; sleep "$interval"; done;
}

fn() {
  local als=$(alias | awk -F'=' '{print $1}' | sed 's/^alias //')
  local fns=$(declare -f | grep -Ev '^_|^git_|^prompt_' | grep '^[a-zA-Z_][a-zA-Z0-9_]* ()' | awk '{print $1}')
  local all=$(printf "%s\n%s" "$als" "$fns" | sort -u)
  if [[ "$1" == 'ls' ]]; then
    echo "$all" | tr '\n' ' '
  elif [[ -z "$1" ]]; then
    local selection=$(echo "$all" | fzf --prompt="Alias or Function: ")
    [[ -n "$selection" ]] && print -z "$selection"
  else
    echo "Usage: fn [ls]"
  fi
}

# --- Generators ---
uuid() {
  uuidgen | tr \[:upper:\] \[:lower:\] | _print_and_copy
}

keygen() {
  read 'length?Length (default: 12): '; local length=${length:-12}
  openssl rand -base64 "$length" | _print_and_copy
}

b64() {
  read 'string?String: '; read 'mode?Encode or Decode? (e/d): '
  echo "$string" | base64 $([[ $mode =~ ^[Dd]$ ]] && echo "-d") | _print_and_copy
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

_print_and_copy() {
  tee >(pbcopy) && echo 'Copied!'
}

