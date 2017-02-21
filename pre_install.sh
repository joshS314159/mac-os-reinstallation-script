#!/bin/bash


f_sublime_files(){
    # #####################
    # SUBLIME
    # #####################
    # keybindings
    readonly sublime_keybindings="~/Library/Application Support/Sublime Text 3/Packages/User/Default (OSX).sublime-keymap"
    readonly repo_sublime_keybindings="~/Documents/Repositories/mac-os-reinstallation-script/preferences/sublime/keybindings/Default (OSX).sublime-keymap"
    cp "$sublime_keybindings" "$repo_sublime_keybindings"
}


f_homebrew_setup(){
    brew bundle dump --force --file="$(pwd)/Brewfile"
}

f_back_to_usb_folder(){
    readonly backup_dir="$HOME/Downloads/mac-os-reinstallation-package"
    mkdir -p "$backup_dir"

    cp -r ~/Documents/Sync/Mackup "$backup_dir/Mackup"
    cp -r ~/Documents/Repositories/mac-os-reinstallation-script "$backup_dir/mac-os-reinstallation-script"
}

f_main(){
    f_sublime_files
    f_homebrew_setup
    f_back_to_usb_folder
}
f_main