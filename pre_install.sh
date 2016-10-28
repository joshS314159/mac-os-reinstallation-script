#!/bin/bash

# #####################
# SUBLIME
# #####################
# keybindings
readonly sublime_keybindings="~/Library/Application Support/Sublime Text 3/Packages/User/Default (OSX).sublime-keymap"
readonly repo_sublime_keybindings="~/Documents/Repositories/mac-os-reinstallation-script/preferences/sublime/keybindings/Default (OSX).sublime-keymap"
cp "$sublime_keybindings" "$repo_sublime_keybindings"