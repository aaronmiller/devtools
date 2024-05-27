#!/usr/bin/env bash

git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref

  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return
    fi
  done

  echo master
}

grbim() {
  git rebase --interactive "$(git_main_branch)"
}

_gbDl() {
  git branch | grep -v "$(git_main_branch)" | grep "amiller" | xargs git branch -D
}

_gbDr() {
  git branch -r | grep -v "$(git_main_branch)" | grep "amiller" | sed "s/origin\///g" | xargs git push --delete origin
}

groot() {
  cd "$(git root)" || return
}
