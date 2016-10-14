#!/bin/bash

# ############################## #
# TO DO 
# ############################## #
# automate pref/config files
# > little snitch
# > btt 
# > bartender
# > dash
# > hazel
# > iterm
# > sublime
# > tower
# > viscosity
# 
# important stuff
# > keys
# > vagrant+virtual box
# > work

# ############################## #
# install arrays
# ############################## #
readonly homebrew_apps=(
  "zsh"
  "git"
)

readonly caskroom_apps=(
  "1password"
  "alfred"
  "appcleaner"
  "bartender"
  "bee"
  "bettertouchtool"
  "boxcryptor"
  "choosy"
  "cocoarestclient"
  "cryptomator"
  "cyberduck"
  "dash"
  "dropbox"
  "flux"
  "fork"
  "gpgtools"
  "hazel"
  "iterm2"
  "kaleidoscope"
  "keybase"
  "little-snitch"
  "logitech-control-center"
  "logitech-unifying"
  "paw"
  "slack"
  "sublime-text"
  "torbrowser"
  "tower"
  "vagrant"
  "virtualbox"
  "viscosity"
  "xld"
  # security
  "blockblock"
  "knockknock"
  "taskexplorer"
  "lockdown"
  "kextviewr"
)

readonly url_app_dir="~/Downloads/url_apps"
readonly url_apps=(
  "https://pqrs.org/latest/karabiner-elements-latest.dmg"
  "http://appldnld.apple.com/STP/031-85776-20161012-4FE1F068-8FE4-11E6-9739-60687FA31755/SafariTechnologyPreview.dmg"
)

readonly repo_stuff_dir="~/Documents/Repositories"
readonly repo_stuff=(
  # themes
  "https://github.com/dracula/sublime"
  "https://github.com/dracula/alfred"
  "https://github.com/dracula/iterm"
  "https://github.com/dracula/slack"
  "https://github.com/Miw0/sodareloaded-theme"
  # config
  "/Users/<user>/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package"
  "https://packagecontrol.io/installation"
  # security
  "https://bitbucket.org/objective-see/deploy/downloads/RansomWhere_1.1.0.zip"
  "https://bitbucket.org/objective-see/deploy/downloads/OverSight_1.0.0.zip"
  "https://bitbucket.org/objective-see/deploy/downloads/DHS_1.3.1.zip"
  "https://bitbucket.org/objective-see/deploy/downloads/WhatsYourSign_1.2.1.zip"
)


# APP STORE
# Haskell
# Keynote
# Pages
# Numbers
# Patterns
# Pixelmator
# Reeder
# Wunderlist
# Twitter


# ############################## #
# init homebrew
# ############################## #
# INSTALL HOMEBREW
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# INSTALL CASKROOM
brew tap caskroom/cask


# ############################## #
# do the installations
# ############################## #
# INSTALLATIONS
for i in "${homebrew_apps[@]}"
do
  brew install $i
done


for i in "${caskroom_apps[@]}"
do
  brew cask install $i
done


mkdir -p "$url_app_dir"
for i in "${url_apps[@]}"
do
  curl $i > "$url_app_dir"
done



mkdir -p "$repo_stuff_dir"
for i in "${repo_stuff[@]}"
do
  git clone "$repo_stuff" -C "$repo_stuff_dir"
done
