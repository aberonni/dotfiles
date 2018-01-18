#!/bin/bash

BREW_PACKAGES="${RESOURCES_DIRECTORY}/brew/brew_packages"
BREW_CASK_PACKAGES="${RESOURCES_DIRECTORY}/brew/brew_cask_packages"

function tap_brew_repositories(){
	brew tap caskroom/versions
	brew tap homebrew/services
}

function install_brew_packages(){
	cat ${BREW_PACKAGES} | xargs brew install
}

function install_brew_cask_packages(){
	cat ${BREW_CASK_PACKAGES} | xargs brew cask install
}

function cleanup_brew(){
  brew cleanup
  brew cask cleanup
}

function backup_brew_packages(){
  brew list > ${BREW_PACKAGES}
}

function backup_brew_cask_packages(){
  brew cask list > ${BREW_CASK_PACKAGES}
}

function install_apps(){

  run "tap repositories"
  tap_brew_repositories
  
  run "install java"
  brew cask install java

  run "install brew packages"
  install_brew_packages

  run "install brew cask packages"
  install_brew_cask_packages

  run "cleanup brew"
  cleanup_brew
}

function backup_apps(){
  run "backup brew packages"
  backup_brew_packages

  run "backup brew cask packages"
  backup_brew_cask_packages
}
