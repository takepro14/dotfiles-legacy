# Shell commands utilities

alias ls='ls -G'
alias ll="ls -lG -D '%y-%m-%d %H:%M'"
alias la="ls -laG -D '%y-%m-%d %H:%M'"
alias load='set -a; source ./.env; set +a;'
alias ze="nvim $HOME/.zshrc"
alias zr="source $HOME/.zshrc"
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
alias vim='nvim'
alias vimi='nvim -u ${HOME}/.dotfiles/config/nvim/init-minimal.lua'
alias hatebu='open https://b.hatena.ne.jp/hotentry/it'

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

b64() {
  read 'string?String: '
  read 'mode?Encode or Decode? (e/d): '
  [[ "$mode" == "e" || "E" ]] && echo -n $string | base64 || echo -n $string | base64 -d
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
  file1=$(fzf --prompt="File 1: " --preview="cat {}") && echo "File 1: $file1" || return 1
  file2=$(fzf --prompt="File 2: " --preview="cat {}") && echo "File 2: $file2" || return 1
  nvim -d $file1 $file2
}

killp() {
  local cpu_col=3
  local pid=$(ps aux | sort -rk $cpu_col | fzf --header="$(ps aux | head -n 1)" | awk '{print $2}')
  [[ -n "$pid" ]] && kill -9 "$pid" && echo "Killed process $pid"
}

# ex. loc 2024-01-01 2024-12-31
loc() {
  git log --numstat --pretty="%H" --author=$(git config user.name) \
    --since="$1" --until="$2" --no-merges \
    | awk 'NF==3 {add+=$1; del+=$2} END {printf("%d (+%d, -%d)\n", add+del, add, del)}'
}

zconfig() {
  echo "\n--- Config Files ---"; echo "ZDOTDIR: $ZDOTDIR\nZSH: $ZSH\n.zshrc: ${ZDOTDIR:-$HOME}/.zshrc"
  echo "\n--- Env Variables ---"; env
  echo "\n--- Options ---"; set -o
  echo "\n--- Key Bindings ---"; bindkey
  echo "\n--- Aliases ---"; alias
  echo "\n--- Functions ---"; functions | awk '/^[-_a-zA-Z0-9]+ \(\) \{$/ {print $1}'
}
