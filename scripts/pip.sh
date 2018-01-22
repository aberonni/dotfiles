#!/bin/bash

PIP_PACKAGES="${RESOURCES_DIRECTORY}/pip/requirements.txt"

function install_pip_packages(){
  run "installing pip"
  sudo easy_install pip
  run "fixing permissions"
  sudo chown -R $USER /Library/Python/2.7
  sudo chown -R $USER /usr/local/bin/pbr
  run "install pip packages"
  sudo pip install -r ${PIP_PACKAGES}
}

function backup_pip_packages(){
  run "backup pip packages"
  pip freeze > $PIP_PACKAGES
}
