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

b64enc() {
  echo -n $1 | base64
}

b64dec() {
  echo -n $1 | base64 -d
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

zconfig() {
  echo "\n--- Config Files ---"; echo "ZDOTDIR: $ZDOTDIR\nZSH: $ZSH\n.zshrc: ${ZDOTDIR:-$HOME}/.zshrc"
  echo "\n--- Env Variables ---"; env
  echo "\n--- Options ---"; set -o
  echo "\n--- Key Bindings ---"; bindkey
  echo "\n--- Aliases ---"; alias
  echo "\n--- Functions ---"; functions | awk '/^[-_a-zA-Z0-9]+ \(\) \{$/ {print $1}'
}
