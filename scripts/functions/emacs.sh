#!/usr/bin/env bash

clear_emacs_cache() {
  cd ${HOME}/.config/emacs/.local/cache/ || return;
  rm -rf autosave projectile projectile.cache projectile.projects recentf savehist saveplace treemacs-persist undo-fu-session
}
