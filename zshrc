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
export FZF_DEFAULT_OPTS='--height 50% --reverse'
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
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey -e  # enable emacs style key bind

# Language specific settings
export PATH="$HOME/.nodenv/bin:$PATH"
export GOPATH=$HOME/go
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
eval "$(hub alias -s)"
eval "$(nodenv init -)"
eval "$(rbenv init - zsh)"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"

# Language specific utilities
for file in $HOME/.dotfiles/utils/*.zsh; do
  [ -f "$file" ] && source "$file"
done

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
