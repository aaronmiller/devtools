#!/usr/bin/env bash

if [[ $(uname -s) == "Darwin" ]]; then
  . "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
else
  . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
