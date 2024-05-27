#!/usr/bin/env bash

if [[ $(uname -s) == "Darwin" ]]; then
  for file in "${DEVTOOLS_DIR}/scripts/env/"*; do
    if [[ $file != *"index.sh" ]]; then
      . $file
    fi
  done
fi
