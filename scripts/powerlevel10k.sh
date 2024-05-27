#!/usr/bin/env bash

if [[ $(uname -s) == "Darwin" ]]; then
  # Powerlevel10k Theme
  . "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"

  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi
