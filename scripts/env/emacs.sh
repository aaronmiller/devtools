#!/usr/bin/env bash

export DOOMDIR="${HOME}/.doom.d"
export EMACSDIR="${HOME}/.config/emacs"
export LSP_USE_PLISTS="true"

[[ $TERM == "tramp" ]] && unsetopt zle && PS1='$ ' && return
