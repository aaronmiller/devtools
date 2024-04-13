#!/usr/bin/env bash

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
  unset ZLE_RPROMPT_INDENT
  alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi
