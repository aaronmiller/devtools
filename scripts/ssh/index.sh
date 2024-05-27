#!/usr/bin/env bash

for file in "${DEVTOOLS_DIR}/scripts/functions/"*; do
  if [[ $file != *"index.sh" ]]; then
    . $file
  fi
done
