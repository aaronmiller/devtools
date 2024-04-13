#!/usr/bin/env bash

setopt ignoreeof
bindkey "^d" bash_ctrl_d
zle -N bash_ctrl_d

bash_ctrl_d() {
  if [[ $CURSOR == 0 && -z $BUFFER ]]; then
    [[ -z $IGNOREEOF || $IGNOREEOF == 0 ]] && exit
    [[ -z $__BASH_IGNORE_EOF ]] && ((__BASH_IGNORE_EOF = IGNOREEOF))
    if [[ $LASTWIDGET == "bash-ctrl-d" ]]; then
      [[ $__BASH_IGNORE_EOF -le 0 ]] && exit
    else
      ((__BASH_IGNORE_EOF = IGNOREEOF))
    fi
    ((__BASH_IGNORE_EOF = __BASH_IGNORE_EOF - 1))
    zle send-break
  else
    zle delete-char-or-list
  fi
}

export IGNOREEOF=1
