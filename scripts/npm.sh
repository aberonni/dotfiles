#!/bin/bash

NPM_PACKAGES="${RESOURCES_DIRECTORY}/npm/npm_packages"

function install_npm_packages(){
  run "install npm packages"
  cat ${NPM_PACKAGES} | xargs npm install --global --quiet
}

function backup_npm_packages(){
  run "backup npm packages"
  npm ls -g --depth=0 --json=true | jq -r '.dependencies | with_entries( select(.value | has("from")) ) | keys[]' > $NPM_PACKAGES
}
