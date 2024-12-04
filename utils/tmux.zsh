# Tmux utilities

# Tmux Set
tmset() {
  tmux new-session -d -s "🧛‍♂️ takepro14" -n '.' -c "${HOME}/.dotfiles"
  tmux new-window -t takepro14 -n 'Dropbox' -c "${HOME}/Dropbox"
  tmux new-window -t takepro14 -n 'dev' -c "${HOME}/dev"
  tmat
}

# Tmux Attach
tmat() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --prompt="Select a tmux session: ")
  [[ -z $session ]] && echo "No session selected." && return 1
  tmux attach-session -t $session
}

# Tmux IDE
tmide() {
  tmux split-window -h
  tmux resize-pane -R 30
  tmux split-window -v
  tmux select-pane -t 0
  nvim
}
