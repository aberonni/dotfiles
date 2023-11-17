#!/bin/bash

BREW_PACKAGES="${RESOURCES_DIRECTORY}/brew/brew_packages"
BREW_CASK_PACKAGES="${RESOURCES_DIRECTORY}/brew/brew_cask_packages"

function tap_brew_repositories(){
  brew tap homebrew/cask-versions
	brew tap homebrew/services
  brew tap mongodb/brew
  brew tap homebrew/cask-fonts
}

function install_brew_packages(){
  while IFS='' read -r line || [[ -n "$line" ]]; do
    brew install "$line"
  done < "${BREW_PACKAGES}"
}

function install_brew_cask_packages(){
  while IFS='' read -r line || [[ -n "$line" ]]; do
    brew install --cask "$line"
  done < "${BREW_CASK_PACKAGES}"
}

function backup_brew_packages(){
  brew list --formula > "${BREW_PACKAGES}"
}

function backup_brew_cask_packages(){
  brew list --cask > "${BREW_CASK_PACKAGES}"
}

function install_apps(){

  run "tap repositories"
  tap_brew_repositories

  run "install brew packages"
  install_brew_packages

  run "install brew cask packages"
  install_brew_cask_packages
}

function backup_apps(){
  run "backup brew packages"
  backup_brew_packages

  run "backup brew cask packages"
  backup_brew_cask_packages
}
