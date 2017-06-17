#!/bin/bash




function homebrew_setup(){
    brew bundle dump --force --file="$(pwd)/Brewfile"
}

function back_to_usb_folder(){
    local -r backup_dir="$HOME/Downloads/mac-os-reinstallation-package"
    mkdir -p "$backup_dir"

    cp -r ~/Documents/Sync/Mackup "$backup_dir/Mackup"
    cp -r ~/Documents/Repositories/mac-os-reinstallation-script "$backup_dir/mac-os-reinstallation-script"
}

function main(){
    # sublime_files
    homebrew_setup
    # back_to_usb_folder
}
main