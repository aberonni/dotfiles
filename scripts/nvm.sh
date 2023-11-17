#!/bin/bash

NVM_DIR="$HOME/.nvm"

function install_nvm {

  message "check for nvm installation"
  if ! command_exists 'nvm'; then
    run "installing nvm"
  
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    \. "$NVM_DIR/nvm.sh"
  else
    message "nvm already installed"
  fi

  cd ${DOTFILES_DIRECTORY}
  run "installing latest node for nvm"
  nvm install node
}
