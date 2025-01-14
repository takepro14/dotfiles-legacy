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
  local windows=($(jq -c '.windows[]' "$config" | sed "s|\$HOME|$HOME|g"))
  tmux new-session -d -s "$name" \
    -n $(_window_title "${windows[1]}") \
    -c $(_window_path "${windows[1]}")
  for window in "${windows[@]:1}"; do
    tmux new-window -t "$name" \
      -n $(_window_title "$window") \
      -c $(_window_path "$window")
  done
  tmux select-window -t "$name:1"
  tmux attach-session -t "$name"
}

_window_title() {
  echo "$1" | jq -r '.title'
}

_window_path() {
  echo "$1" | jq -r '.path'
}

ide() {
  tmux split-window -v
  tmux resize-pane -D 10
  tmux split-window -h
  tmux select-pane -t 0
  nvim
}

