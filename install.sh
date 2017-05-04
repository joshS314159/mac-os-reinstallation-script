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
# "/Users/<user>/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package"



declare -r url_app_dir="~/Downloads/url_apps"
declare -r url_apps=(
  # "https://pqrs.org/latest/karabiner-elements-latest.dmg"
  "http://appldnld.apple.com/STP/031-85776-20161012-4FE1F068-8FE4-11E6-9739-60687FA31755/SafariTechnologyPreview.dmg"
  "http://www.fujitsu.com/global/support/products/computing/peripheral/scanners/scansnap/software/s1300m-setup.html"
)

declare -r do_repos_stuff_manually=true
declare -r repo_stuff_dir="~/Documents/Repositories"
declare -r repo_stuff=(
  # themes
  "https://github.com/dracula/sublime"
  "https://github.com/dracula/alfred"
  "https://github.com/dracula/iterm"
  "https://github.com/dracula/slack"
  "https://github.com/dracula/zsh.git"
  "https://github.com/Miw0/sodareloaded-theme"
)




function init_homebrew(){
    # INSTALL HOMEBREW
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # TAP HOMEBREW BUNDLER AND INSTALL
    brew tap homebrew/bundle
}


function install_from_homebrew(){
    brew bundle
}


function install_from_url(){
    # apps at urls
    mkdir -p "$url_app_dir"
    for i in "${url_apps[@]}"; do
      curl $i > "$url_app_dir"
    done    
}


function install_from_repo(){
    # >> do this manually
    # apps/files at repos
    if [ "$do_repos_stuff_manually" = false ]; then
      mkdir -p "$repo_stuff_dir"
      for i in "${repo_stuff[@]}"; do
        git init
        git remote add origin "$i"
        git pull origin master
      done
    fi
}


function init_cli(){
    # ############################## #
    # other setup
    # ############################## #
    # ll alias 
    echo "alias ll='ls -lGaf'" >> ~/.bash_profile

    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    # set dracula theme for zsh
    $DRACULA_THEME=""
    $OH_MY_ZSH="~/.oh-my-zsh/themes"
    ln -s $DRACULA_THEME/zsh/dracula.zsh-theme $OH_MY_ZSH/themes/dracula.zsh-theme
}


function main(){
    init_homebrew

    install_from_homebrew
    install_from_url
    install_from_repo

    init_cli
}
main




 