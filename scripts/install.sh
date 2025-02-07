#!/usr/bin/env bash

if [[ $(uname -s) == "Darwin" ]]; then
  install_asdf_plugins() {
    cut -d " " -f 1 <"${HOME}/.tool-versions" | while read -r line; do asdf plugin add "${line}"; done
    asdf install
  }

  update_asdf_plugins() {
    cut -d " " -f 1 <"${HOME}/.tool-versions" | while read -r line; do asdf plugin update "${line}"; done
  }

  install_symlinks() {
    if [[ -x "$(command -v stow)" ]]; then
      /bin/bash -c "$(stow --adopt -d "${DOTFILES_DIR}" . --ignore="\.DS_Store" --ignore="\.git" --ignore="\.gitignore" --ignore="\.gitmodules")"
      cd "${DOTFILES_DIR}" || return
      git restore .
      cd "${HOME}" || return
    else
      echo -n "stow is not installed. Please install stow."
    fi
  }

  uninstall_symlinks() {
    if [[ -x "$(command -v stow)" ]]; then
      /bin/bash -c "$(stow -d "${DOTFILES_DIR}" -D . --ignore="\.DS_Store" --ignore="\.git" --ignore="\.gitignore" --ignore="\.gitmodules")"
    else
      echo -n "stow does not exist, or is already uninstalled."
    fi
  }

  set_custom_zsh() {
    homebrew_zsh="$(brew --prefix)/bin/zsh"

    if ! grep -Fxq "${homebrew_zsh}" /etc/shells; then
      sudo /bin/bash -c "echo ${homebrew_zsh} >> /etc/shells"
      chsh -s "$(brew --prefix)/bin/zsh"
    else
      echo -n "${homebrew_zsh} is already set in /etc/shells."
    fi
  }

  unset_custom_zsh() {
    homebrew_zsh="$(brew --prefix)/bin/zsh"

    if grep -Fxq "${homebrew_zsh}" /etc/shells; then
      sudo /bin/bash -c "sed -i /${homebrew_zsh//\//\\\/}/d /etc/shells"
      chsh -s /bin/zsh
    else
      echo -n "${homebrew_zsh} is already unset in /etc/shells."
    fi
  }

  install_homebrew() {
    if [[ ! -x "$(command -v brew)" ]]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      echo "brew is already installed."
    fi
  }

  uninstall_homebrew() {
    if [[ -x "$(command -v brew)" ]]; then
      echo -n "Do you want to uninstall homebrew? Type y or yes: "

      while true; do
        read -r input

        if [[ $input = "y" || $input = "yes" ]]; then
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

          return
        else
          echo -n "${input} is an invalid option. Please type y or yes: "
        fi
      done
    else
      echo -n "homebrew does not exist, or is already uninstalled."
    fi
  }

  install_alacritty() {
    if [[ ! -f "${DEVTOOLS_DIR}/alacritty/target/release/alacritty" ]]; then
      cd "${DEVTOOLS_DIR}/alacritty" || return

      if [[ $(uname -m) == "arm64" ]]; then
        rustup target add aarch64-apple-darwin
      elif [[ $(uname -m) == "x86_64" ]]; then
        rustup target add x86_64-apple-darwin
      fi

      make app
      sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
      ln -sf "${DEVTOOLS_DIR}/alacritty/target/release/osx/Alacritty.app" "/Applications"
      defaults write org.alacritty AppleFontSmoothing -int 0
    else
      echo -n "alacritty is already installed."
    fi
  }

  uninstall_alacritty() {
    if [[ -f "${DEVTOOLS_DIR}/alacritty/target/release/alacritty" ]]; then
      echo -n "Do you want to uninstall alacritty? Type y or yes: "

      while true; do
        read -r input

        if [[ $input = "y" || $input = "yes" ]]; then
          cd "${DEVTOOLS_DIR}/alacritty" && rm -rf target && git clean -dfx
          rm -rf "Applications/Alacritty.app"

          return
        else
          echo -n "${input} is an invalid option. Please type y or yes: "
        fi
      done
    else
      echo -n "alacritty does not exist, or is already uninstalled."
    fi
  }

  install_emacs() {
    if [[ $1 == "-f" || ! -x "$(command -v emacs)" ]]; then
      cd "${DEVTOOLS_DIR}/emacs" && ./autogen.sh && ./configure --with-json --with-modules --with-native-compilation && make && make install
      ln -sf "${DEVTOOLS_DIR}/emacs/nextstep/Emacs.app" "/Applications"
      defaults write org.gnu.Emacs AppleFontSmoothing -int 0
    else
      echo -n "emacs is already installed."
    fi
  }

  install_doomemacs() {
    if [[ ! -d $EMACSDIR ]]; then
      cd "${HOME}" || return
      git clone --depth 1 https://github.com/doomemacs/doomemacs "${HOME}/.config/emacs"
      "${HOME}/.config/emacs/bin/doom" install
      return
    elif [[ ! -d "${EMACSDIR}/.local" ]]; then
      doom install
      return
    else
      echo -n "doomemacs is already installed."
    fi
  }

  uninstall_doomemacs() {
    if [[ ! -d $EMACSDIR ]]; then
      echo -n "doomemacs does not exist, or is already uninstalled."
      return
    elif [[ -d "${EMACSDIR}/.local" ]]; then
      echo -n "Do you want to uninstall doomemacs? Type y or yes: "

      while true; do
        read -r input

        if [[ $input = "y" || $input = "yes" ]]; then
          cd "${EMACSDIR}" && rm -rf .local/

          return
        else
          echo -n "${input} is an invalid option. Please type y or yes: "
        fi
      done
    else
      echo -n "doomemacs does not exist, or is already uninstalled."
    fi
  }

  install_hack_font() {
    if [[ ! -f "${HOME}/Library/Fonts/HackNerdFontMono-Regular.ttf" ]]; then
      cp "${DEVTOOLS_DIR}/Hack/build/ttf/"* "${HOME}/Library/Fonts/"
    else
      echo -n "font hack is already installed."
    fi
  }

  uninstall_hack_font() {
    if [[ -f "${HOME}/Library/Fonts/HackNerdFontMono-Regular.ttf" ]]; then
      echo -n "Do you want to uninstall hack font? Type y or yes: "

      while true; do
        read -r input

        if [[ $input = "y" || $input = "yes" ]]; then
          /bin/bash -c "$(rm -rf "${HOME}/Library/Fonts/Hack"*.ttf)"

          return
        else
          echo -n "${input} is an invalid option. Please type y or yes: "
        fi
      done
    else
      echo -n "hack font does not exist, or is already uninstalled."
    fi
  }

  configure_gatech_access() {
    input="machine github.gatech.edu\n"
    echo -n "enter your gatech username: "
    read -r login
    input+="login ${login}\n"
    echo -n "enter your gatech password: "
    read -rs password
    input+="password ${password}"
    echo "${input}" >~/.netrc
  }

  install_remouseable() {
    if [[ ! -x "$(command -v remouse)" ]]; then
      echo -n "installing remouseable"
      cd "${DEVTOOLS_DIR}/remouseable" && make build || return
      cd /usr/local/bin && ln -sf "${DEVTOOLS_DIR}/remouseable/.build/remouse" . || return
    else
      echo -n "remouseable already installed"
    fi
  }
fi

install_ohmyzsh() {
  if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

    if [[ -n $WORK_DOTFILES_DIR ]]; then
      ln -sf "${WORK_DOTFILES_DIR}/.zshrc" "${HOME}/.zshrc"
    else
      ln -sf "${DOTFILES_DIR}/.zshrc" "${HOME}/.zshrc"
    fi
  else
    echo -n "ohmyzsh is already installed."
  fi
}

uninstall_ohmyzsh() {
  if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    echo -n "Do you want to uninstall ohmyzsh? Type y or yes: "

    while true; do
      read -r input

      if [[ $input = "y" || $input = "yes" ]]; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/uninstall.sh)"

        if [[ -n $WORK_DOTFILES_DIR ]]; then
          ln -sf "${WORK_DOTFILES_DIR}/.zshrc" "${HOME}/.zshrc"
        else
          ln -sf "${DOTFILES_DIR}/.zshrc" "${HOME}/.zshrc"
        fi

        return
      else
        echo -n "${input} is an invalid option. Please type y or yes: "
      fi
    done
  else
    echo "ohmyzsh does not exist, or is already uninstalled."
  fi
}

if [[ $(uname -s) == "Linux" ]]; then
  install_packages() {
    sudo apt-get update && sudo apt-get install -y \
      keychain \
      ripgrep \
      zsh \
      zsh-autosuggestions \
      zsh-syntax-highlighting
  }

  install_powerlevel10k() {
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    ln -sf "${DOTFILES_DIR}/.p10k.zsh" "${HOME}/.p10k.zsh"
  }
fi

fix_compaudit() {
  compaudit | xargs chmod g-w,o-w
}

ssh_keygen() {
  if [[ ! -f "${HOME}/.ssh/id_ed25519" ]]; then
    echo -n "Please enter your email address for the ssh key comment: "
    read -r input

    ssh-keygen -o -a 100 -t ed25519 -C "${input}"
  fi
}

install_dotfiles() {
  if [[ ! -d $DOTFILES_DIR ]]; then
    /bin/bash -c "$(git clone --recurse-submodules git@github.com:aaronmiller/dotfiles.git "${HOME}"/dotfiles)"
  else
    echo -n "Dotfiles is already installed."
  fi
}

uninstall_dotfiles() {
  if [[ -d $DOTFILES_DIR ]]; then
    echo -n "Do you want to uninstall dotfiles? Type y or yes: "

    while true; do
      read -r input

      if [[ $input = "y" || $input = "yes" ]]; then
        /bin/bash -c "$(rm -rf "${HOME}/dotfiles/")"

        return
      else
        echo -n "${input} is an invalid option. Please type y or yes: "
      fi
    done
  else
    echo -n "dotfiles does not exist, or is already uninstalled."
  fi
}
