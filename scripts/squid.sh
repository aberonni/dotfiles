#!/bin/bash

function setup_squid() {
  run "copy squid conf"
	cp "${RESOURCES_DIRECTORY}/squid/squid.conf" "/usr/local/etc"
}

function backup_squid() {
  run "backup squid conf"
  cp "/usr/local/etc/squid.conf" "${RESOURCES_DIRECTORY}/squid"
}
