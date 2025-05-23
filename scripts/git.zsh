local GIT_USERNAME=$(git config user.name)

alias g='git'
alias gi='git init'
alias gp='git push'
alias gf='git fetch'
alias gm='git merge'
alias gcm='git commit'
alias gst='git status'
alias gsh='git stash'
alias gsw='git switch'

# unchange
guch() {
  git diff --name-only | fzf -m | xargs git restore
}

# unstage
gus() {
  git diff --staged --name-only | fzf -m | xargs git restore --staged
}

# uncommit
gucm() {
  if [[ -z "$1" ]]; then
    local commit=$(git log --oneline | fzf | awk '{print $1}')
    [[ -n "$commit" ]] && git reset --soft "$commit"^
  elif [[ "$1" == 'redo' ]]; then
    git reset --soft HEAD@{1}
  fi
}

# untrack
gut() {
  fzf | xargs git rm --cached -r
}

gco() {
  git branch | fzf | xargs git switch
}

gbr() {
  if [[ "$1" == "rm" ]]; then
    git branch | fzf | xargs git branch -D
  elif [[ "$1" == "parent" ]]; then
    git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -1 | awk -F'[]~^[]' '{print $2}'
  else
    git branch "$@"
  fi
}

gl() {
  if [[ "$1" == "hash" ]]; then
    git log --no-merges --date=short \
      --pretty='format:%C(yellow)%h %C(green)%cd %C(blue)%an%C(red)%d %C(reset)%s'
  elif [[ "$1" == "graph" ]]; then
    git log --graph -10 --branches --remotes --tags \
      --format=format:'%Cgreen%h %Creset• %<(75,trunc)%s (%cN, %ar) %Cred%d' \
      --date-order
  else
    git log "$@"
  fi
}

gd() {
  if [[ "$#" -eq 0 ]]; then
    git diff --name-only | fzf -m | awk '{print $NF}' | tr '\n' '\0' | xargs -0 git diff
  else
    git diff "$@"
  fi
}

ga() {
  if [[ "$#" -eq 0 ]]; then
    git status -s | fzf -m | awk '{print $NF}' | tr '\n' '\0' | xargs -0 git add
  else
    git add "$@"
  fi
}

gloc() {
  read 'start_date?Start Date (default: 2025-01-01): '
  read 'end_date?End Date (default: 2025-12-31): '
  start_date=${start_date:-2025-01-01}
  end_date=${end_date:-2025-12-31}
  git log --numstat --pretty='%H' --author="$GIT_USERNAME" \
    --since="$start_date" --until="$end_date" --no-merges |
    awk 'NF==3 {add+=$1; del+=$2} END {printf("%d (+%d, -%d)\n", add+del, add, del)}'
}

repo() {
  local selected=$(ghq list -p | awk '{print $0 " " $0}' | sed -E 's|(.*/)([^/]+/[^/]+)$|\2 \1\2|' | fzf --with-nth=1 --delimiter=" ")
  [[ -n "$selected" ]] && cd $(echo "$selected" | awk '{print $2}')
}

# ex. ghrepo | ghrepo create | ghrepo clone
ghrepo() {
  if [[ -z "$1" ]]; then
    gh repo view --web
  elif [[ "$1" == "create" ]]; then
    local repo_name=$(basename "$(pwd)")
    gh repo create "$repo_name" --public --source=. --push
  elif [[ "$1" == "clone" ]]; then
    local username="$GIT_USERNAME"
    local reponame=$(gh repo list "$username" | fzf | awk '{print $1}')
    [[ -n "$reponame" ]] && ghq get "$reponame"
  fi
}

ghpr() {
  gh pr view --web
}

# ex. ghcm | ghcm <commit-hash>
ghcm() {
  if [[ -z "$1" ]]; then
    git log --oneline --abbrev-commit | fzf | awk '{print $1}' | xargs gh browse
  else
    gh browse "$1"
  fi
}
