#!/usr/bin/env bash

export WORKON_HOME="${HOME}/.virtualenvs"

if [[ -x "$(command -v virtualenvwrapper.sh)" ]]; then
  . virtualenvwrapper.sh
fi
