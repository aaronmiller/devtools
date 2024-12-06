#!/usr/bin/env bash

install_default_python_packages() {
  while read -r line; do pip install "${line}"; done <"${HOME}/.default-python-packages"
}
