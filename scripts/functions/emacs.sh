#!/usr/bin/env bash

clear_emacs_cache() {
  cd ${HOME}/.config/emacs/.local/cache/ || return;
  rm -rf projectile.cache projectile.projects recentf savehist saveplace treemacs-persist
}
