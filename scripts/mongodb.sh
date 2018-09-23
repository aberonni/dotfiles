#!/bin/bash

# Based on official docs
# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/
function setup_mongodb(){
    run "[mongodb] create the data directory"
    sudo mkdir -p /data/db
    
    run "[mongodb] set correct permissions on data directory"
    sudo chown -R $USER /data/db
}
