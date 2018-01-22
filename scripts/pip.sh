#!/bin/bash

PIP_PACKAGES="${RESOURCES_DIRECTORY}/pip/pip_packages"

function install_pip_packages(){
  run "installing pip"
  sudo easy_install pip
  run "fixing permissions"
  sudo chown -R $USER /usr/local/bin/pbr
  run "install pip packages"
  cat ${PIP_PACKAGES} | xargs sudo pip install --ignore-installed six
}

function backup_pip_packages(){
  run "backup pip packages"
  pip list --format=json | jq -r '.[] | .name' > $PIP_PACKAGES
}
