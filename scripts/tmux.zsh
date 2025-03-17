TMUX_SCRIPT_CONFIG=$HOME/.dotfiles/scripts/config/tmux.json

alias tmls='tmux ls'
alias tmk='tmux kill-server'
alias tma='tmux attach'

tmux!() {
  tmux kill-server 2>/dev/null
  local config="$TMUX_SCRIPT_CONFIG"
  local name=$(jq -r '.name' "$config")
  local windows=($(jq -c '.windows[]' "$config" | sed "s|\$HOME|$HOME|g"))
  tmux new-session -d -s "$name" -c $(echo "${windows[1]}" | jq -r)
  for window in "${windows[@]:1}"; do
    tmux new-window -t "$name" -c $(echo "$window" | jq -r)
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
