#!/bin/bash

function install_fnm {

  message "check for fnm installation"
  if ! command_exists 'fnm'; then
    run "installing fnm"
    brew install fnm
  else
    message "fnm already installed"
  fi

  run "installing latest node for fnm"
  eval "$(fnm env --use-on-cd)"
  fnm install --lts
}
