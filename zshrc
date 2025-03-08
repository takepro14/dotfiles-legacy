# Zplug
source ~/.zplug/init.zsh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
zplug load

# Zsh settings
export LANG=en_US.UTF-8
export EDITOR=nvim
export XDG_CONFIG_HOME=~/.config
export PURE_PROMPT_SYMBOL="$"
export FZF_DEFAULT_OPTS='--height 85% --reverse'
setopt auto_cd
setopt auto_pushd
setopt nobeep
setopt complete_aliases
setopt physical
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_find_no_dups
setopt hist_reduce_blanks
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history
bindkey -e  # enable emacs style key bind

# Language specific settings
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
eval "$(/opt/homebrew/bin/brew shellenv)"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
export PATH="$(go env GOPATH)/bin:$PATH"
export PATH="$(gem environment gemdir)/bin:$PATH"

# Launch docker engine
! pgrep -f "Docker.app" > /dev/null && open -a Docker

# Language specific utilities
for file in $HOME/.dotfiles/scripts/*.zsh; do
  [[ -f "$file" ]] && source "$file"
done

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

