#!/usr/bin/env bash

if [[ $(uname -s) == "Darwin" ]]; then
  omscs() {
    cd "${HOME}/omscs/" || return
  }

  6515() {
    cd "${HOME}/omscs/omscs-cs6515/" || return
  }

  add_notes() {
    if [[ $PWD = "${HOME}/omscs/"* ]]; then
      git add .
      git commit -m "adding notes."
      git push
    else
      echo "not in omscs dir"
    fi
  }
fi
