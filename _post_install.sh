#!/bin/bash

set -o pipefail


#########################
# GLOBALS ###############
#########################
declare -r FILE_NAME=$(basename $0)
declare -r ARGS="$@"

declare -r APPLE_SCRIPTS="./support/scripts/apple_scripts/"
declare -r BASH_SCRIPTS="./support/scripts/bash/"

declare -r do_repos_stuff_manually=true




#######################################################################################################
#######################################################################################################
# read paramters in ###################################################################################
#######################################################################################################
#######################################################################################################
function read_parameters() {
    local -r args="$1"
    
    # Transform long options to short ones
    for arg in "$args"; do
      shift
      case "$arg" in
        "--help") set -- "$@" "-h" ;;
        "--rest") set -- "$@" "-r" ;;
        "--ws")   set -- "$@" "-w" ;;
        *)        set -- "$@" "$arg"
      esac
    done

    # Default behavior
    local rest=false
    local ws=false

    # Parse short options
    OPTIND=1
    while getopts "hrw" opt
    do
      case "$opt" in
        "h") print_usage; exit 0 ;;
        "r") rest=true ;;
        "w") ws=true ;;
        "?") print_usage >&2; exit 1 ;;
      esac
    done
    shift $(expr $OPTIND - 1) # remove options from positional parameters
}



#######################################################################################################
#######################################################################################################
# print the usage #####################################################################################
# displays usage information to the user for this script ##############################################
# http://docopt.org ###################################################################################
#######################################################################################################
#######################################################################################################
function print_usage(){
    echo "-----------------------------------------------------------------------------------------------------"
    echo "Usage: $PROGRAM ( --help )"
    echo 
    echo "       --help | -h        HELP: displays this usage page"
    echo
    echo "-----------------------------------------------------------------------------------------------------"
}


#######################################################################################################
#######################################################################################################
# create the folder structure #########################################################################
#######################################################################################################
#######################################################################################################
function setup_folder_structure(){
    mkdir -p "~/Documents/Developer"
    
    mkdir -p "~/Documents/Developer/Repositories/"
    mkdir -p "~/Documents/Developer/Virtual Machines/"
    mkdir -p "~/Documents/Developer/Working/"

    mkdir -p "~/Documents/DevonThink"
    
    mkdir -p "~/Documents/1Password"
    mkdir -p "~/Documents/DevonThink"
    mkdir -p "~/Documents/nvAlt2"
    mkdir -p "~/Documents/ScanSnap Processing"
}





#######################################################################################################
#######################################################################################################
# install homebrew ####################################################################################
#######################################################################################################
#######################################################################################################
function install_homebrew(){
    # INSTALL HOMEBREW
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # TAP HOMEBREW BUNDLER AND INSTALL
    brew tap homebrew/bundle
}


#######################################################################################################
#######################################################################################################
# install apps in brewfile ############################################################################
#######################################################################################################
#######################################################################################################
function install_apps_in_brewfile(){
    brew bundle
}



#######################################################################################################
#######################################################################################################
# set bash aliases ####################################################################################
#######################################################################################################
#######################################################################################################
function set_bash_aliases(){
    echo "alias ll='ls -lGaf'" >> ~/.bash_profile
}


#######################################################################################################
#######################################################################################################
# set zsh as default shell ############################################################################
#######################################################################################################
#######################################################################################################
function set_zsh_as_default_shell(){
    chsh -s $(which zsh)
}



#######################################################################################################
#######################################################################################################
# install oh my zsh ###################################################################################
#######################################################################################################
#######################################################################################################
function install_oh_my_zsh(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}



#######################################################################################################
#######################################################################################################
# set zsh theme #######################################################################################
#######################################################################################################
#######################################################################################################
function set_zsh_dracula_theme(){
    local -r DRACULA_THEME="./support/resources/themes/dracula/zsh/dracula.zsh-theme" 
    local -r OH_MY_ZSH="~/.oh-my-zsh/themes"
    local -r ZSH_CONFIG="$HOME/.zshrc"

    # link theme
    ln -s $DRACULA_THEME $OH_MY_ZSH
    
    # remove the current ZSH_THEME="<text>" line, if it exists
    sed -i.bak '/.*ZSH_THEME.*/d' $ZSH_CONFIG
    
    # echo dracula theme setting to config file
    echo 'ZSH_THEME="dracula"' > $ZSH_CONFIG
}






#######################################################################################################
#######################################################################################################
# set "hacker" defaults ###############################################################################
#######################################################################################################
#######################################################################################################
function setup_hacker_defaults(){
    (   cd $BASH_SCRIPTS
        bash "mac_os_for_hackers.sh"
    )
}


#######################################################################################################
#######################################################################################################
# clear all applications from the dock ################################################################
#######################################################################################################
#######################################################################################################
function clear_dock(){
    dockutil --remove all #remove all the crap from the dock
}

#######################################################################################################
#######################################################################################################
# add applications to the dock ########################################################################
#######################################################################################################
#######################################################################################################
function add_desired_apps_to_dock(){
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
    
    (   cd $themes_dir"/alfred"
        open "Dracula.alfredappearance"
    )
}

function install_dracula::iterm(){
    # https://draculatheme.com/iterm/
    local -r themes_dir="$1"

    # (   cd $themes_dir"/iterm"
    #     open "Dracula.itermcolors"
    # )
}

function install_dracula::slack(){
    # https://draculatheme.com/slack/
    local -r themes_dir="$1"

    # (   cd $themes_dir"/slack"
    #     open "Dracula.alfredappearance"
    # )
}

function install_dracula::sublime(){
    # https://draculatheme.com/sublime/
    local -r themes_dir="$1"

    # (   cd $themes_dir"/sublime"
    #     open "Dracula.tmTheme"
    # )
}

function install_dracula::textmate(){
    # https://draculatheme.com/textmate/
    local -r themes_dir="$1"

    (   cd $themes_dir"/textmate"
        open "Dracula.tmTheme"
    )
}

function install_dracula::textual(){
    # https://draculatheme.com/textual/
    local -r themes_dir="$1"

    # (   cd $themes_dir"/textual"
    #     open "Dracula.alfredappearance"
    # )
}

function install_dracula::zsh(){
    # https://draculatheme.com/zsh/
    local -r themes_dir="$1"
    local -r DRACULA_THEME="$themes_dir/zsh/dracula.zsh-theme" 
    local -r OH_MY_ZSH="~/.oh-my-zsh/themes"
    local -r ZSH_CONFIG="$HOME/.zshrc"

    # link theme
    ln -s $DRACULA_THEME $OH_MY_ZSH
    
    # remove the current ZSH_THEME="<text>" line, if it exists
    sed -i.bak '/.*ZSH_THEME.*/d' $ZSH_CONFIG
    
    # echo dracula theme setting to config file
    echo 'ZSH_THEME="dracula"' > $ZSH_CONFIG
}



function install_dracula(){
    local -r themes_dir="./support/resources/themes/dracula"
    
    install_dracula::alfred $themes_dir
    # install_dracula::iterm $themes_dir
    # install_dracula::slack $themes_dir
    # install_dracula::sublime $themes_dir
    install_dracula::textmate $themes_dir
    # install_dracula::textual $themes_dir
    install_dracula::zsh $themes_dir
    
     
}



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


