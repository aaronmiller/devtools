#!/usr/bin/env bash

install_default_python_packages() {
  while read -r line; do pipx install "${line}"; done <"${HOME}/.requirements.txt"
}

uninstall_default_python_packages() {
  pipx uninstall-all
}
