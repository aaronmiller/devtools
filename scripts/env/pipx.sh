#!/usr/bin/env bash

export PIPX_BIN_DIR="${HOME}/bin"
export PIPX_DEFAULT_PYTHON="${HOME}/.asdf/installs/python/$(cat < "${HOME}/.tool-versions" | grep python | cut -d " " -f 3)/bin/python3"
