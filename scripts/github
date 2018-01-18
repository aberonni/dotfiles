#!/bin/bash

function add_ssh_configs() {

    printf "%s\n" \
        "Host github.com" \
        "  IdentityFile $1" \
        "  LogLevel ERROR" >> ~/.ssh/config

    message "Add SSH configs"

}

function copy_public_ssh_key_to_clipboard () {
    pbcopy < "$1"
    message "Copied public SSH key to clipboard"
}

function generate_ssh_keys() {
    ask "Please provide an email address: " && printf "\n"
    ssh-keygen -t rsa -b 4096 -C "$(get_answer)" -f "$1"

    message "Generate SSH keys"
}

function open_github_ssh_page() {
    declare -r GITHUB_SSH_URL="https://github.com/settings/ssh"
    open "$GITHUB_SSH_URL"
}

function test_ssh_connection() {
    while true; do
        ssh -T git@github.com &> /dev/null
        [ $? -eq 1 ] && break

        sleep 5
    done
}

function set_github_ssh_key() {
    local sshKeyFileName="$HOME/.ssh/github"

    # If there is already a file with that
    # name, generate another, unique, file name.

    if [ -f "$sshKeyFileName" ]; then
        sshKeyFileName="$(mktemp -u "$HOME/.ssh/github_XXXXX")"
    fi

    generate_ssh_keys "$sshKeyFileName"
    add_ssh_configs "$sshKeyFileName"
    copy_public_ssh_key_to_clipboard "${sshKeyFileName}.pub"
    open_github_ssh_page
    test_ssh_connection \
        && rm "${sshKeyFileName}.pub"
}

function setup_github() {
    ssh -T git@github.com &> /dev/null

    if [ $? -ne 1 ]; then
        set_github_ssh_key
    fi

    message "Set up GitHub SSH keys"
}
