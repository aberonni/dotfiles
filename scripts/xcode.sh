#!/bin/bash

function agree_with_xcode_licence() {
    # Automatically agree to the terms of the `Xcode` license.
    # https://github.com/alrra/dotfiles/issues/10

    sudo xcodebuild -license accept &> /dev/null
    message "Agree to the terms of the Xcode licence"
}

function are_xcode_command_line_tools_installed() {
    xcode-select --print-path &> /dev/null
}

function install_xcode_app() {
    # If necessary, prompt user to install `Xcode`.
    if ! is_xcode_installed; then
        open "macappstores://itunes.apple.com/en/app/xcode/id497799835"
    fi

    # Wait until `Xcode` is installed.
    execute \
        "until is_xcode_installed; do \
            sleep 5; \
         done" \
        "Installing Xcode.app"
}

function install_xcode_command_line_tools() {
    # If necessary, prompt user to install
    # the `Xcode Command Line Tools`.
    xcode-select --install &> /dev/null

    # Wait until the `Xcode Command Line Tools` are installed.
    execute \
        "until are_xcode_command_line_tools_installed; do \
            sleep 5; \
         done" \
        "Installing Xcode Command Line Tools"
}

function is_xcode_installed() {
    [ -d "/Applications/Xcode.app" ]
}

function set_xcode_developer_directory() {
    # Point the `xcode-select` developer directory to
    # the appropriate directory from within `Xcode.app`.
    #
    # https://github.com/alrra/dotfiles/issues/13

    sudo xcode-select -switch "/Applications/Xcode.app/Contents/Developer" &> /dev/null
    message "Making 'xcode-select' developer directory point to the appropriate directory from within Xcode.app"
}

install_xcode() {
    install_xcode_command_line_tools
    install_xcode_app
    set_xcode_developer_directory
    agree_with_xcode_licence
}
