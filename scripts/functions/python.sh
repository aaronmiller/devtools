#!/usr/bin/env bash

install_default_python_packages() {
  while read -r line; do pip3 install "${line}"; done <"${HOME}/.default-python-packages"
  asdf reshim
}

uninstall_default_python_packages() {
  pip3 freeze | while read -r line; do pip3 uninstall -y "${line}"; done
  asdf reshim
}
