#!/bin/bash

# CASKROOM 
readonly caskroom_apps=(
  "1password"
  "alfred"
  "appcleaner"
  "bartender"
  "bee"
  "bettertouchtool"
  "boxcryptor"
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
)

readonly url_app_dir="~/Downloads/url_apps"
readonly url_apps=(
  "https://pqrs.org/latest/karabiner-elements-latest.dmg"
  "http://appldnld.apple.com/STP/031-85776-20161012-4FE1F068-8FE4-11E6-9739-60687FA31755/SafariTechnologyPreview.dmg"
)

readonly repo_stuff_dir="~/Documents/Repositories"
readonly repo_stuff=(
  "https://github.com/dracula/sublime"
  "https://github.com/dracula/alfred"
  "https://github.com/dracula/iterm"
  "https://github.com/dracula/slack"
  "https://github.com/Miw0/sodareloaded-theme"
  "/Users/<user>/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package"
  "https://packagecontrol.io/installation"
)


# APP STORE
# Haskell
# Keynote
# Patterns
# Pixelmator
# Reeder
# Wunderlist


# INIT
# INSTALL HOMEBREW
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# INSTALL CASKROOM
brew tap caskroom/cask



# INSTALLATIONS
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
