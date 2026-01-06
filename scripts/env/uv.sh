#!/usr/bin/env bash

export UV_PYTHON="${HOME}/.asdf/installs/python/$(cat < "${HOME}/.tool-versions" | grep python | cut -d " " -f 3)/bin/python3"
