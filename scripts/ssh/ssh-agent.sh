#!/usr/bin/env bash

if [[ $(uname -s) == "Linux" ]]; then
  if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    eval $(ssh-agent)
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
  fi

  export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi
