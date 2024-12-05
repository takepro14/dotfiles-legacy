# Tmux utilities

tmset() {
  tmux kill-session
  local session_name='🧛‍♂️ takepro14'
  tmux new-session -d -s "$session_name" -n '.' -c "${HOME}/.dotfiles"
  tmux new-window -t "$session_name" -n 'Dropbox' -c "${HOME}/Dropbox"
  tmux new-window -t "$session_name" -n 'dev' -c "${HOME}/dev"
  tmat
}

tmat() {
  local session=$(tmux ls -F "#{session_name}" | fzf --prompt="Session: ")
  [[ -n $session ]] && tmux a -t $session
}

tmide() {
  tmux split-window -h
  tmux resize-pane -R 30
  tmux split-window -v
  tmux select-pane -t 0
  nvim
}
