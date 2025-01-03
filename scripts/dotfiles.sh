#!/bin/bash

CONFIG_FILES="aliases exports functions gitconfig gitignore_global nanorc p10k.zsh zshrc"
CONFIG_FILES_BACKUP_FOLDER="${HOME}/dotfiles_backup"
CONFIG_FILES_DIR="${RESOURCES_DIRECTORY}/dotfiles"

function backup_old_dotfiles(){
    bckfld="${CONFIG_FILES_BACKUP_FOLDER}/$(date +%s)"
    mkdir -p ${bckfld}
    for file in ${CONFIG_FILES}; do
        if [ -L "$file" ]; then
          # no need to backup if its a link. just unlink it
          unlink "${HOME}/.${file}"
        else
          mv "${HOME}/.${file}" ${bckfld}
        fi
    done
}

function link_dotfiles(){
    for file in ${CONFIG_FILES}; do
        link "${CONFIG_FILES_DIR}/${file}" "${HOME}/.${file}"
    done
}

function setup_dotfiles(){
  run "backup current dotfiles"
  backup_old_dotfiles

  run "linking new dotfiles"
  link_dotfiles
}
