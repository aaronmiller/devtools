#!/usr/bin/env bash

if [[ $(uname -s) == "Darwin" ]]; then
  omscs() {
    cd "${HOME}/omscs/"
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
