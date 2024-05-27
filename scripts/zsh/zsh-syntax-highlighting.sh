#!/usr/bin/env bash

if [[ $(uname -s) == "Darwin" ]]; then
  . "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
  . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
