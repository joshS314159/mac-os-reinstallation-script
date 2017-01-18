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
  "git"
  "mackup"
  "mas"
  "screenfetch"     
  "sudolikeaboss"  
  "zsh"             
)

readonly caskroom_apps=(
    "1password"
    "alfred"
    "appcleaner"
    "bartender"
    "bee"
    "bettertouchtool"
    "choosy"
    "cocoarestclient"
    "cryptomator"
    "cyberduck"
    "dash"
    "dropbox"
    "flux"
    "hazel"
    "iterm2"
    "kaleidoscope"
    "keybase"
    "mplayerx"
    "paw"
    "sublime-text"
    "tower"
    "transmission"
    "vagrant"
    "virtualbox"
    "viscosity"
    "xld"
)

readonly caskroom_security_apps=(
    "blockblock"
    "boxcryptor"
    "dhs"
    "dnscrypt"
    "kextviewr"
    "knockknock"
    "little-flocker"
    "little-snitch"
    "oversight"
    "ransomwhere"
    "santa"
    "security-growler"
    "taskexplorer"
    "torbrowser"
)

readonly do_mas_apps_manually=true
readonly mas_apps=(
    "1Blocker"
    "Amphetamine"
    "Deliveries"
    "Haskell"
    "Home Inventory"
    "Keynote"
    "Numbers"
    "Pages"
    "Patterns"
    "Pixelmator"
    "Reeder"
    "Slack"
    "Textual"
    "Twitter"
    "Unclutter"
    "WiFi Explorer"
    "Wunderlist"
)

readonly url_app_dir="~/Downloads/url_apps"
readonly url_apps=(
  # "https://pqrs.org/latest/karabiner-elements-latest.dmg"
  "http://appldnld.apple.com/STP/031-85776-20161012-4FE1F068-8FE4-11E6-9739-60687FA31755/SafariTechnologyPreview.dmg"
)

readonly do_repos_stuff_manually=true
readonly repo_stuff_dir="~/Documents/Repositories"
readonly repo_stuff=(
  # themes
  "https://github.com/dracula/sublime"
  "https://github.com/dracula/alfred"
  "https://github.com/dracula/iterm"
  "https://github.com/dracula/slack"
  "https://github.com/dracula/zsh.git"
  "https://github.com/Miw0/sodareloaded-theme"
)


# "/Users/<user>/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package"




f_init_homebrew(){
    # ############################## #
    # init homebrew
    # ############################## #
    # INSTALL HOMEBREW
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # TAP CASKROOM
    brew tap caskroom/cask

    #TAP SUDOLIKEABOSS
    brew tap ravenac95/sudolikeaboss
}


f_install_brew_apps(){
    # ############################## #
    # do the installations
    # ############################## #
    # homebrew (always do this first)
    for i in "${homebrew_apps[@]}"
    do
      brew install $i
    done
}


f_install_cask_apps(){
    # caskroom (mac gui apps)
    for i in "${caskroom_apps[@]}"
    do
      brew cask install $i
    done
    
    for i in "${caskroom_security_apps[@]}"
    do
      brew cask install $i
    done
}


f_install_mas_apps(){
    # >> do this manually
    # mas (mac gui apps from mas)
    if [ "$do_mas_apps_manually" = false ]; then
      for i in "${mas_apps[@]}"
      do
        app_id=$(mas search "$i" | head -1 | awk '{ print $1 }')
        mas install "$app_id"
      done
    fi
}


f_install_url_apps(){
    # apps at urls
    mkdir -p "$url_app_dir"
    for i in "${url_apps[@]}"
    do
      curl $i > "$url_app_dir"
    done
    
}

f_install_repo_apps(){
    # >> do this manually
    # apps/files at repos
    if [ "$do_repos_stuff_manually" = false ]; then
      mkdir -p "$repo_stuff_dir"
      for i in "${repo_stuff[@]}"
      do
        # git clone "$repo_stuff" "$repo_stuff_dir"
        git init
        git remote add origin "$i"
        git pull origin master
      done
    fi
    
}




f_cli_init(){
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



f_main(){
    f_init_homebrew
    f_install_brew_apps
    f_install_cask_apps
    f_install_mas_apps
    f_install_url_apps
    f_install_repo_apps
    f_cli_init
}
f_main




 