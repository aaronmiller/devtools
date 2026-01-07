#!/usr/bin/env bash

install_default_uv_tools() {
  while read -r line; do uv tool install "${line}"; done <"${HOME}/.requirements.txt"
}
