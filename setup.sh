#!/bin/bash

DOTFILES_DIRECTORY="${HOME}/git/dotfiles"
RESOURCES_DIRECTORY="${DOTFILES_DIRECTORY}/resources"
DOTFILES_TARBALL_PATH="https://github.com/aberonni/dotfiles/tarball/main"
DOTFILES_GIT_REMOTE="https://github.com/aberonni/dotfiles.git"
DOTFILES_GIT_REMOTE_SSH="git@github.com:aberonni/dotfiles.git"

ESC_SEQ="\x1b["
COL_RESET=${ESC_SEQ}"39;49;00m"
COL_RED=${ESC_SEQ}"31;01m"
COL_GREEN=${ESC_SEQ}"32;01m"
COL_YELLOW=${ESC_SEQ}"33;01m"
COL_BLUE=${ESC_SEQ}"34;01m"
COL_MAGENTA=${ESC_SEQ}"35;01m"
COL_CYAN=${ESC_SEQ}"36;01m"

function run(){
    echo -e "${COL_MAGENTA} ⇒ ${COL_RESET}$1..."
}

function message(){
    echo -e "${COL_BLUE}[INFO] - ${COL_RESET}$1..."
}

function warn(){
    echo -e "${COL_YELLOW}[WARNING] - ${COL_RESET} "$1
}

function error(){
    echo -e "${COL_RED}[ERROR] - ${COL_RESET} "$1
}

# Test whether a command exists
# $1 - cmd to test
function command_exists(){
    if [ $(type -P $1) ]; then
      return 0
    fi
    return 1
}

function check_requirements(){
  # If missing, download and extract the dotfiles repository
  message "check if dotfiles downdloading is required"
  if [[ ! -d ${DOTFILES_DIRECTORY} ]]; then
    run "downloading dotfiles directory"
    mkdir -p ${DOTFILES_DIRECTORY}
    # Get the tarball
    curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOTFILES_TARBALL_PATH}
    # Extract to the dotfiles directory
    tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOTFILES_DIRECTORY}
    # Remove the tarball
    rm -rf ${HOME}/dotfiles.tar.gz
  else
    message "nothing to do, everything is up to date"
  fi

  # Check for Homebrew
  message "check for brew installation"
  if ! command_exists 'brew'; then
    run "installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew doctor
  else
    message "nothing to do, brew already installed"
  fi

  message "check for git installation"
  if ! command_exists 'git'; then
    run "installing Git"
    brew install git --without-completions
  else
    message "nothing to do, git already installed"
  fi

  # jq is used to backup npm packages, so regarding it will
  # installed or not wit brew script, is better to have it
  message "check for jq installation"
  if ! command_exists 'jq'; then
    run "installing jq"
    brew install jq
  else
    message "nothing to do, jq already installed"
  fi

  cd ${DOTFILES_DIRECTORY}

  # Initialize the git repository if it's missing
  message "initializing git repository"
  if ! $(git rev-parse --is-inside-work-tree &> /dev/null); then
    run "adding remote repository"
    git init
    git remote add origin ${DOTFILES_GIT_REMOTE}
    git fetch origin main
    # Reset the index and working tree to the fetched HEAD
    git reset --hard FETCH_HEAD
    git branch --set-upstream-to origin/main
    # Remove any untracked files
    git clean -fd
  else
    message "nothing to do, everything is up to date"
  fi

  run "updating from remote"
  git pull --rebase origin master
}


function install_system(){
    
    echo ""
    echo ""
    echo "###########################"
    echo "## Starting setup system ##"
    echo "###########################"
    echo ""
    echo ""

    message "install fnm"
    install_fnm

    message "install brew apps"
    install_apps
    
    message "setup mongodb"
    setup_mongodb

    message "copy dotfiles"
    setup_dotfiles

    message "setup ZSH"
    set_zsh_shell

    message "setup fzf"
    $(brew --prefix)/opt/fzf/install

    message "install xcode"
    install_xcode

    message "install npm packages"
    install_npm_packages

    message "setup vscode"
    setup_vscode

    message "install fonts"
    install_fonts

    message "set osx preferences"
    set_osx_preferences

    message "set github ssh key"
    set_github_ssh_key

    git remote set-url origin ${DOTFILES_GIT_REMOTE_SSH}

    echo ""
    echo ""
    echo "#############################################################################################"
    echo "## Setup finished. Quit and reopen Terminal and enjoy!                                     ##"
    echo "## BONUS: if you need patched font for Powerline, go to https://github.com/powerline/fonts ##"
    echo "## and https://github.com/ryanoasis/nerd-fonts#font-installation                           ##"
    echo "#############################################################################################"
    echo ""
    echo ""
}

function backup_system(){

    echo ""
    echo ""
    echo "############################"
    echo "## Starting backup system ##"
    echo "############################"
    echo ""
    echo ""

    message "backup brew and brew cask packages"
    backup_apps

    message "backup npm packages"
    backup_npm_packages

    message "backup vscode"
    backup_vscode

    message "backup fonts"
    backup_fonts

    echo ""
    echo ""
    echo "########################"
    echo "## Done backup system ##"
    echo "########################"
    echo ""
    echo ""

}

check_requirements

source ./utils.sh
source ./scripts/apps.sh
source ./scripts/dotfiles.sh
source ./scripts/fonts.sh
source ./scripts/github.sh
source ./scripts/npm.sh
source ./scripts/fnm.sh
source ./scripts/osx.sh
source ./scripts/vscode.sh
source ./scripts/mongodb.sh
source ./scripts/xcode.sh
source ./scripts/zsh.sh

if [[ $1 =~ (-b| --backup) ]]; then
  backup_system
else
  sudo -v
  # Keep-alive: update existing sudo time stamp until the script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  install_system
fi

