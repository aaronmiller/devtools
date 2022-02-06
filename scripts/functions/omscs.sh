#!/usr/bin/env bash

omscs() {
  cd "${CODE_DIR}/omscs/"
}

add_notes() {
  if [[ $PWD = "${CODE_DIR}/omscs/"* ]]; then
    git add .; git commit -m "adding notes."; git push
  else
    echo "not in omscs dir"
  fi
}
