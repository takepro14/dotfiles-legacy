# ===================================
# Tmux utilities
# ===================================

alias tmls='tmux ls'
alias tmk='tmux kill-session'
alias tma='tmux attach'

tmux!() {
  tmux kill-session
  local session_name='🧛‍♂️ takepro14'
  tmux new-session -d -s "$session_name" -n '.' -c "${HOME}/.dotfiles"
  tmux new-window -t "$session_name" -n 'Dropbox' -c "${HOME}/Dropbox"
  tmux new-window -t "$session_name" -n 'dev' -c "${HOME}/dev"
  tmux select-window -t "$session_name"
  local session=$(tmux ls -F "#{session_name}" | fzf --prompt="Session: ")
  [[ -n $session ]] && tmux a -t "$session" \; select-window -t "$session:1"
}

ide() {
  tmux split-window -v
  tmux resize-pane -D 10
  tmux split-window -h
  tmux select-pane -t 0
  nvim
}

