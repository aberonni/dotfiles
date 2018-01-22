#!/bin/bash

VSCODE_SUPPORT_DIR="${HOME}/Library/Application Support/Code - Insiders/User"

VSCODE_RESOURCES_EXTENSIONS="${RESOURCES_DIRECTORY}/vscode/extensions"
VSCODE_RESOURCES_SETTINGS_DIR="${RESOURCES_DIRECTORY}/vscode/settings"

function copy_files(){
  TARGET=$1
  DEST=$2

  for file in "${TARGET}"/*; do
    cp "${file}" "${DEST}"
  done
}

function create_vscode_dir(){
  DIR=$1
  if [ ! -d "$DIR" ]; then
    mkdir -p "${DIR}"
  fi
}

function copy_vscode_settings(){
  copy_files "${VSCODE_RESOURCES_SETTINGS_DIR}" "${VSCODE_SUPPORT_DIR}"
}

function install_vscode_extensions(){
  cat ${VSCODE_RESOURCES_EXTENSIONS} | xargs -L 1 code-insiders --install-extension
}

function backup_vscode_settings(){
  copy_files "${VSCODE_SUPPORT_DIR}" "${VSCODE_RESOURCES_SETTINGS_DIR}"
}

function backup_vscode_extensions(){
  code-insiders --list-extensions > $VSCODE_RESOURCES_EXTENSIONS
}

function setup_vscode(){
  run "install"
  brew cask install visual-studio-code-insiders

  run "creating settings directory"
  create_vscode_dir "${VSCODE_SUPPORT_DIR}"

  run "copy settings"
  copy_vscode_settings

  run "install extensions"
  install_vscode_extensions
}

function backup_vscode(){
  run "backup vscode settings"
  backup_vscode_settings

  run "backup vscode extensions"
  backup_vscode_extensions
}
