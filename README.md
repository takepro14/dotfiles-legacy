# dotfiles

## Installation

```sh
zsh -c "$(gh api /repos/takepro14/dotfiles/contents/setup/install.zsh | jq -r '.download_url' | xargs curl -s)"
```

## Uninstallation

```sh
cd ~/.dotfiles && ./setup/uninstall.zsh
```
