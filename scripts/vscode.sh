#!/bin/bash

VSCODE_BACKUP_FOLDER="${RESOURCES_DIRECTORY}/vscode/backup"

VSCODE_SUPPORT_DIR="${HOME}/Library/Application Support/Code - Insiders/User"
VSCODE_SUPPORT_SETTINGS="${HOME}/Library/Application Support/Code - Insiders/User/settings.json"
VSCODE_SUPPORT_KEYBINDINGS="${HOME}/Library/Application Support/Code - Insiders/User/keybindings.json"

VSCODE_RESOURCES_EXTENSIONS="${RESOURCES_DIRECTORY}/vscode/extensions"
VSCODE_RESOURCES_SETTINGS="${RESOURCES_DIRECTORY}/vscode/settings/settings.json"
VSCODE_RESOURCES_KEYBINDINGS="${RESOURCES_DIRECTORY}/vscode/settings/keybindings.json"

function create_vscode_dir(){
  DIR=$1
  if [ ! -d "$DIR" ]; then
    mkdir -p "${DIR}"
  fi
}

function backup_vscode_settings(){
  bckfld="${CONFIG_FILES_BACKUP_FOLDER}/$(date +%s)"
  mkdir -p ${bckfld}
  
  if [ -L "$VSCODE_SUPPORT_SETTINGS" ]; then
    # no need to backup if its a link. just unlink it
    unlink "${VSCODE_SUPPORT_SETTINGS}"
  else
    mv "${VSCODE_SUPPORT_SETTINGS}" ${bckfld}
  fi

  if [ -L "$VSCODE_SUPPORT_KEYBINDINGS" ]; then
    # no need to backup if its a link. just unlink it
    unlink "${VSCODE_SUPPORT_KEYBINDINGS}"
  else
    mv "${VSCODE_SUPPORT_KEYBINDINGS}" ${bckfld}
  fi
}

function link_vscode_settings(){
  ln -f "${VSCODE_RESOURCES_SETTINGS}" "${VSCODE_SUPPORT_SETTINGS}"
  ln -f "${VSCODE_RESOURCES_KEYBINDINGS}" "${VSCODE_SUPPORT_KEYBINDINGS}"
}

function install_vscode_extensions(){
  cat ${VSCODE_RESOURCES_EXTENSIONS} | xargs -L 1 code-insiders --install-extension
}

function backup_vscode_extensions(){
  code-insiders --list-extensions > $VSCODE_RESOURCES_EXTENSIONS
}

function setup_vscode(){
  run "install"
  brew cask install visual-studio-code-insiders

  run "creating settings directory"
  create_vscode_dir "${VSCODE_SUPPORT_DIR}"

  run "backup old settings"
  backup_vscode_settings

  run "link new settings"
  link_vscode_settings

  run "install extensions"
  install_vscode_extensions
}

function backup_vscode(){

  run "backup vscode extensions"
  backup_vscode_extensions
}
