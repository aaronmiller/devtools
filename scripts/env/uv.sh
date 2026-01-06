#!/usr/bin/env bash

export UV_TOOL_BIN_DIR="${HOME}/.uv/tools/bin"
export UV_TOOL_DIR="${HOME}/.uv/tools"
export UV_PYTHON="${HOME}/.asdf/installs/python/$(cat < "${HOME}/.tool-versions" | grep python | cut -d " " -f 3)/bin/python3"
