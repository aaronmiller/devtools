#!/usr/bin/env bash

if [[ $(uname -s) == "Darwin" ]]; then
  # Powerlevel10k Theme
  . "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"
fi

if [[ $(uname -s) == "Linux" ]]; then
  if [[ -f "${HOME}/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    # Powerlevel10k Theme
    . "${HOME}/powerlevel10k/powerlevel10k.zsh-theme"
  fi
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "${HOME}/.p10k.zsh" ]] || . "${HOME}/.p10k.zsh"
