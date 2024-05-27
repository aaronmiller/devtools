#!/usr/bin/env bash

if [[ $(uname -s) == "Darwin" ]]; then
  . "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
fi
