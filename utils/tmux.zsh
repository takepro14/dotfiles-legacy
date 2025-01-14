# ===================================
# Tmux utilities
# ===================================

alias tmls='tmux ls'
alias tmk='tmux kill-server'
alias tma='tmux attach'

tmux!() {
  tmux kill-server 2>/dev/null
  local config="$HOME/.dotfiles/utils/config/tmux.json"
  local name=$(jq -r '.name' "$config")
  local windows=($(jq -r '.windows[]' "$config" | sed "s|\$HOME|$HOME|g"))
  tmux new-session -d -s "$name" -n "$(basename "${windows[1]}")" -c "${windows[1]}"
  for window in "${windows[@]:1}"; do
    tmux new-window -t "$name" -n "$(basename "$window")" -c "$window"
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

