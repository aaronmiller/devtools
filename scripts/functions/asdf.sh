#!/usr/bin/env bash

if [[ $(uname -s) == "Darwin" ]]; then
  . "$(brew --prefix asdf)/libexec/asdf.sh"
fi
