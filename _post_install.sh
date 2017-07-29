#!/bin/bash

set -e; # exit all shells if script fails
set -u; # exit script if uninitialized variable is used
set -o pipefail; #exit script if anything fails in pipe
# set -x; #debug mode

#########################
# GLOBALS ###############
#########################
# declare -r FILE_NAME=$(basename $0)
declare -r ARGS="$@"
declare -r PROGRAM="$0"

# declare -r APPLE_SCRIPTS="./support/scripts/apple_scripts/"
declare -r BASH_SCRIPTS="./support/scripts/bash/"




#######################################################################################################
#######################################################################################################
# read paramters in ###################################################################################
#######################################################################################################
#######################################################################################################
function read_parameters() {

    local is_dump_homebrew="false"
    
    while getopts ":h" opt; do
      case ${opt} in
        h ) usage
            ;;
        \? ) usage
            ;;
      esac
    done
}



#######################################################################################################
#######################################################################################################
# print the usage #####################################################################################
# displays usage information to the user for this script ##############################################
# http://docopt.org ###################################################################################
#######################################################################################################
#######################################################################################################
function usage(){
    echo "-----------------------------------------------------------------------------------------------------"
    echo "Usage: $PROGRAM ( --help )"
    echo 
    echo "       -h        HELP: displays this usage page"
    echo
    echo "-----------------------------------------------------------------------------------------------------"
}


#######################################################################################################
#######################################################################################################
# create the folder structure #########################################################################
#######################################################################################################
#######################################################################################################
function setup_folder_structure(){
    mkdir -p "$HOME/Documents/Developer"
    
    mkdir -p "$HOME/Documents/Developer/Repositories/"
    mkdir -p "$HOME/Documents/Developer/Virtual Machines/"
    mkdir -p "$HOME/Documents/Developer/Working/"

    mkdir -p "$HOME/Documents/DevonThink"
    
    mkdir -p "$HOME/Documents/1Password"
    mkdir -p "$HOME/Documents/DevonThink"
    mkdir -p "$HOME/Documents/nvAlt2"
    mkdir -p "$HOME/Documents/ScanSnap Processing"
}





#######################################################################################################
#######################################################################################################
# homebrew ############################################################################################
#######################################################################################################
#######################################################################################################
function homebrew::install(){
    # INSTALL HOMEBREW
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # TAP HOMEBREW BUNDLER AND INSTALL
    brew tap homebrew/bundle
}


function homebrew::install_brewfile(){
    brew bundle
}



#######################################################################################################
#######################################################################################################
# shell initialization ################################################################################
#######################################################################################################
#######################################################################################################
function shell::set_aliases(){
    echo "alias ll='ls -lGaf'" >> "$HOME/.bash_profile"
}


function shell:set_zsh_default(){
    chsh -s "$(which zsh)"
}



function shell::install_oh_my_zsh(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}



#######################################################################################################
#######################################################################################################
# set "hacker" defaults ###############################################################################
#######################################################################################################
#######################################################################################################
function setup_hacker_defaults(){
    (   cd "$BASH_SCRIPTS" || return
        bash "mac_os_for_hackers.sh"
    )
}


#######################################################################################################
#######################################################################################################
# dock initialization #################################################################################
#######################################################################################################
#######################################################################################################
function dock::clear(){
    dockutil --remove all #remove all the crap from the dock
}


function dock::add_apps(){
    dockutil --add "/Applications/DEVONthink Pro.app"
    dockutil --add "/Applications/Mail.app"
}





#######################################################################################################
#######################################################################################################
# install dracula themes ##############################################################################
#######################################################################################################
#######################################################################################################

function install_dracula::alfred(){
    # https://draculatheme.com/alfred/
    local -r themes_dir="$1"
    
    (   cd "$themes_dir/alfred" || return
        open "Dracula.alfredappearance"
    )
}

# function install_dracula::iterm(){
    # https://draculatheme.com/iterm/
    # local -r themes_dir="$1"

    # (   cd $themes_dir"/iterm"
    #     open "Dracula.itermcolors"
    # )
# }

# function install_dracula::slack(){
    # https://draculatheme.com/slack/
    # local -r themes_dir="$1"

    # (   cd $themes_dir"/slack"
    #     open "Dracula.alfredappearance"
    # )
# }

# function install_dracula::sublime(){
    # https://draculatheme.com/sublime/
    # local -r themes_dir="$1"

    # (   cd $themes_dir"/sublime"
    #     open "Dracula.tmTheme"
    # )
# }

function install_dracula::textmate(){
    # https://draculatheme.com/textmate/
    local -r themes_dir="$1"

    (   cd "$themes_dir/textmate" || return
        open "Dracula.tmTheme"
    )
}

# function install_dracula::textual(){
    # https://draculatheme.com/textual/
    # local -r themes_dir="$1"

    # (   cd $themes_dir"/textual"
    #     open "Dracula.alfredappearance"
    # )
# }

function install_dracula::zsh(){
    # https://draculatheme.com/zsh/
    local -r themes_dir="$1"
    local -r dracula_theme="$themes_dir/zsh/dracula.zsh-theme" 
    local -r oh_my_zsh="$HOME/.oh-my-zsh/themes"
    local -r zsh_config="$HOME/.zshrc"

    # link theme
    ln -s "$dracula_theme" "$oh_my_zsh"
    
    # remove the current ZSH_THEME="<text>" line, if it exists
    sed -i.bak '/.*ZSH_THEME.*/d' "$zsh_config"
    
    # append dracula theme setting to config file
    echo 'ZSH_THEME="dracula"' >> "$zsh_config"
}



function install_dracula(){
    local -r themes_dir="./support/resources/themes/dracula"
    
    install_dracula::alfred "$themes_dir"
    # install_dracula::iterm $themes_dir
    # install_dracula::slack $themes_dir
    # install_dracula::sublime $themes_dir
    install_dracula::textmate "$themes_dir"
    # install_dracula::textual $themes_dir
    install_dracula::zsh "$themes_dir"
    
     
}



#######################################################################################################
#######################################################################################################
# arq cli install and restore #########################################################################
#######################################################################################################
#######################################################################################################

function arq::retrieve_restore_binary(){
    (   cd "$HOME/Downloads" || return
        wget "https://arqbackup.github.io/arq_restore/arq_restore.zip"
    )
}

# function arq::restore_from_backup(){
#   
# }



#######################################################################################################
#######################################################################################################
# main ################################################################################################
#######################################################################################################
#######################################################################################################


function main(){
    
    read_parameters $ARGS
    


    # setup_folder_structure
    # install_homebrew
    # install_apps_in_brewfile
    # curl_from_url
    # clone_repos
    # set_bash_aliases
    # set_zsh_as_default_shell
    # install_oh_my_zsh
    # set_zsh_dracula_theme
    # setup_hacker_defaults
    # clear_dock
    # add_desired_apps_to_dock


}
main
# 


