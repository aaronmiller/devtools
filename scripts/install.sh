#!/usr/bin/env bash

install_k9s() {
  if [[ ! -x "$(command -v k9s)" ]]; then
    cd "${DEVTOOLS_DIR}/k9s" && make build
  else
    echo -n "k9s is already installed"
  fi
}

uninstall_k9s() {
  if [[ -x "$(command -v k9s)" ]]; then
    echo -n "Do you want to uninstall k9s? Type y or yes: "

    while true; do
      read -r input

      if [[ $input = "y" || $input = "yes" ]]; then
        cd "${DEVTOOLS_DIR}/k9s" && rm -rf execs && git clean -dfx

        return
      else
        echo -n "${input} is an invalid option. Please type y or yes: "
      fi
    done
  else
    echo "k9s does not exist, or is already uninstalled."
  fi
}

ssh_add() {
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
}

install_asdf_programs() {
  cat ~/.tool-versions | cut -d ' ' -f 1 | while read line; do asdf plugin add $line; asdf install $line; done
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
    /bin/bash -c "$(git clone --recurse-submodules git@github.com:aaronmiller/dotfiles.git ${HOME}/dotfiles)"
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

install_symlinks() {
  if [[ -x "$(command -v stow)" ]]; then
    /bin/bash -c "$(stow -d ${DOTFILES_DIR} . --ignore="\.DS_Store" --ignore="\.git")"
  else
    echo -n "stow is not installed. Please install stow."
  fi
}

uninstall_symlinks() {
  if [[ -x "$(command -v stow)" ]]; then
    /bin/bash -c "$(stow -d ${DOTFILES_DIR} -D . --ignore="\.DS_Store" --ignore="\.git")"
  else
    echo -n "stow does not exist, or is already uninstalled."
  fi
}

set_custom_zsh() {
  homebrew_zsh_line=$(tail -n 1 /etc/shells)

  if [[ $homebrew_zsh_line != "/usr/local/bin/zsh" ]]; then
    sudo /bin/bash -c "echo $(brew --prefix)/bin/zsh >> /etc/shells"
  fi

  chsh -s "$(brew --prefix)/bin/zsh"
}

unset_custom_zsh() {
  homebrew_zsh_line=$(tail -n 1 /etc/shells)

  if [[ $homebrew_zsh_line == "/usr/local/bin/zsh" ]]; then
    sudo /bin/bash -c "sed '$d' /etc/shells"
  fi

  chsh -s /bin/zsh
}

install_ohmyzsh() {
  if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

    if [[ ! -z $WORK_DOTFILES_DIR ]]; then
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

        if [[ ! -z $WORK_DOTFILES_DIR ]]; then
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
    cd "${DEVTOOLS_DIR}/alacritty"

    if [[ $(uname -m) == "arm64" ]]; then
      rustup target add aarch64-apple-darwin
    elif [[ $(uname -m) == "x86_64" ]]; then
      rustup target add x86_64-apple-darwin
    fi

    make app
    sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
    ln -sf "${DEVTOOLS_DIR}/alacritty/target/release/osx/Alacritty.app" "/Applications"
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
    cd "${DEVTOOLS_DIR}/emacs" && ./autogen.sh && ./configure --with-json --with-modules --with-native-compilation && gmake && gmake install
    ln -sf "${DEVTOOLS_DIR}/emacs/nextstep/Emacs.app" "/Applications"
  else
    echo -n "emacs is already installed."
  fi
}

install_doomemacs() {
  if [[ ! -d $EMACSDIR ]]; then
    cd ${HOME}
    ln -sf devtools/doomemacs .emacs.d
    doom install
  else
    echo -n "doom emacs is already installed."
  fi
}

uninstall_doomemacs() {
  if [[ -d $EMACSDIR ]]; then
    echo -n "Do you want to uninstall emacs doom? Type y or yes: "

    while true; do
      read -r input
      
      if [[ $input = "y" || $input = "yes" ]]; then
        cd "${DEVTOOLS_DIR}/doomemacs" && rm -rf .local/straight/

        return
      else
        echo -n "${input} is an invalid option. Please type y or yes: "
      fi
    done
  else
    echo -n "doom emacs does not exist, or is already uninstalled."
  fi  
}

install_hack_font() {
  if [[ ! -f "${HOME}/Library/Fonts/HackNerdFontMono-Regular.ttf" ]]; then
    cp build/ttf/* "${HOME}/Library/Fonts/"
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
        /bin/bash -c "$(rm -rf "${HOME}/Library/Fonts/Hack-"*.ttf)"

        return
      else
        echo -n "${input} is an invalid option. Please type y or yes: "
      fi
    done
  else
    echo -n "hack font does not exist, or is already uninstalled."
  fi
}

install_dockfmt() {
  if [[ ! -x dockfmt ]]; then
    /bin/bash -c "$(go install github.com/jessfraz/dockfmt@latest)"
  fi
}
