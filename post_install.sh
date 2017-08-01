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
# print the usage #####################################################################################
# displays usage information to the user for this script ##############################################
# http://docopt.org ###################################################################################
#######################################################################################################
#######################################################################################################
function usage(){
    log_func "${FUNCNAME[0]}"
    echo "
    -----------------------------------------------------------------------------------------------------
     Usage: $PROGRAM ( --help )
     
            -h        HELP: displays this usage page
    
            -f        set up default folder structure
    
            -b        install home brew and install apps from dump file
    
            -u        curl apps at urls
    
            -r        clone data at repos (probably just themes)
    
            -s        setup shell (oh-my-zsh, themes, etc.)
    
            -d        set system defaults (\hacker\ scripts, dock init, etc.)
    
     -----------------------------------------------------------------------------------------------------"
}



#######################################################################################################
#######################################################################################################
# logging #############################################################################################
#######################################################################################################
#######################################################################################################

function log(){
    local -r msg="$1"
    echo "======================> LOG: $msg"
}

function log_func(){
    local -r function_name="$1"
    log "function - $function_name"
}




#######################################################################################################
#######################################################################################################
# read paramters in ###################################################################################
#######################################################################################################
#######################################################################################################
function read_parameters(){
    log_func "${FUNCNAME[0]}"
    local is_dump_homebrew="false"
    local is_setup_folder_structure="false"
    local is_run_homebrew="false"
    local is_curl_at_urls="false"
    local is_clone_repos="false"
    local is_setup_shell="false"
    local is_set_defaults="false"
    local is_do_all="false"
    
    while getopts ":hfbursdz" opt; do
      case "${opt}" in
        h ) usage
            ;;
        f ) is_setup_folder_structure="true"
            ;;
        b ) is_run_homebrew="true"
            ;;
        u ) is_curl_at_urls="true"
            ;;
        r ) is_clone_repos="true"
            ;;
        s ) is_setup_shell="true"
            ;;
        d ) is_set_defaults="true"
            ;;
        z ) is_do_all="true"
            ;;
        \? ) usage
            ;;
      esac
    done
    
    if [[ "$is_do_all" == "true" ]]; then 
        is_setup_folder_structure="true"
        is_run_homebrew="true"
        is_curl_at_urls="true"
        is_clone_repos="true"
        is_setup_shell="true"
        is_set_defaults="true"
    fi
    
    
    readonly IS_SETUP_FOLDER_STRUCTURE="$is_setup_folder_structure"
    readonly IS_RUN_HOMEBREW="$is_run_homebrew"
    readonly IS_CURL_AT_URLS="$is_curl_at_urls"
    readonly IS_CLONE_REPOS="$is_clone_repos"
    readonly IS_SETUP_SHELL="$is_setup_shell"
    readonly IS_SET_DEFAULTS="$is_set_defaults"
}



#######################################################################################################
#######################################################################################################
# create the folder structure #########################################################################
#######################################################################################################
#######################################################################################################
function setup_folder_structure(){
    log_func "${FUNCNAME[0]}"
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
    log_func "${FUNCNAME[0]}"
    
    # INSTALL HOMEBREW
    local -r homebrew_url="https://raw.githubusercontent.com/Homebrew/install/master/install"
    /usr/bin/ruby -e "$(curl -fsSL $homebrew_url)"

    # TAP HOMEBREW BUNDLER AND INSTALL
    brew tap homebrew/bundle
}


function homebrew::install_brewfile(){
    log_func "${FUNCNAME[0]}"
    brew bundle
}



#######################################################################################################
#######################################################################################################
# shell initialization ################################################################################
#######################################################################################################
#######################################################################################################

function shell:set_zsh_default(){
    log_func "${FUNCNAME[0]}"
    chsh -s "$(which zsh)"
}



function shell::install_oh_my_zsh(){
    log_func "${FUNCNAME[0]}"
    local -r oh_my_zsh_url="https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    sh -c "$(curl -fsSL $oh_my_zsh_url)"
}



#######################################################################################################
#######################################################################################################
# set "hacker" defaults ###############################################################################
#######################################################################################################
#######################################################################################################
function setup_hacker_defaults(){
    log_func "${FUNCNAME[0]}"
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
    log_func "${FUNCNAME[0]}"
    dockutil --remove all #remove all the crap from the dock
}


function dock::add_apps(){
    log_func "${FUNCNAME[0]}"
    dockutil --add "/Applications/DEVONthink Pro.app"
    dockutil --add "/Applications/Mail.app"
}





#######################################################################################################
#######################################################################################################
# install dracula themes ##############################################################################
#######################################################################################################
#######################################################################################################

function install_dracula::alfred(){
    log_func "${FUNCNAME[0]}"
    # https://draculatheme.com/alfred/
    local -r themes_dir="$1"
    
    (   cd "$themes_dir/alfred" || return
        open "Dracula.alfredappearance"
    )
}

function install_dracula::iterm(){
    log_func "${FUNCNAME[0]}"
    # https://draculatheme.com/iterm/
    # local -r themes_dir="$1"

    # (   cd $themes_dir"/iterm"
    #     open "Dracula.itermcolors"
    # )
}

function install_dracula::slack(){
    log_func "${FUNCNAME[0]}"
    # https://draculatheme.com/slack/
    # local -r themes_dir="$1"

    # (   cd $themes_dir"/slack"
    #     open "Dracula.alfredappearance"
    # )
}

function install_dracula::sublime(){
    log_func "${FUNCNAME[0]}"
    # https://draculatheme.com/sublime/
    # local -r themes_dir="$1"

    # (   cd $themes_dir"/sublime"
    #     open "Dracula.tmTheme"
    # )
}

function install_dracula::textmate(){
    log_func "${FUNCNAME[0]}"
    # https://draculatheme.com/textmate/
    local -r themes_dir="$1"

    (   cd "$themes_dir/textmate" || return
        open "Dracula.tmTheme"
    )
}

function install_dracula::textual(){
    log_func "${FUNCNAME[0]}"
    # https://draculatheme.com/textual/
    # local -r themes_dir="$1"

    # (   cd $themes_dir"/textual"
    #     open "Dracula.alfredappearance"
    # )
}

function install_dracula::zsh(){
    log_func "${FUNCNAME[0]}"
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
    log_func "${FUNCNAME[0]}"
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
    log_func "${FUNCNAME[0]}"
    (   cd "$HOME/Downloads" || return
        wget "https://arqbackup.github.io/arq_restore/arq_restore.zip"
    )
}

function arq::restore_from_backup(){
    log_func "${FUNCNAME[0]}"
#   
}





#######################################################################################################
#######################################################################################################
# main ################################################################################################
#######################################################################################################
#######################################################################################################

function main(){
    log_func "${FUNCNAME[0]}"
    read_parameters $ARGS
    
    if [[ "$IS_SETUP_FOLDER_STRUCTURE" == "true" ]]; then
        setup_folder_structure
    fi
    
    if [[ "$IS_RUN_HOMEBREW" == "true" ]]; then
        install_homebrew
        install_apps_in_brewfile
    fi
    
    if [[ "$IS_CURL_AT_URLS" == "true" ]]; then
        curl_from_url
    fi
    
    if [[ "$IS_CLONE_REPOS" == "true" ]]; then 
        clone_repos
    fi

    if [[ "$IS_SETUP_SHELL" == "true" ]]; then
        set_zsh_as_default_shell
        install_oh_my_zsh
        set_zsh_dracula_theme
    fi
    
    if [[ "$IS_SET_DEFAULTS" == "true" ]]; then
        setup_hacker_defaults
        clear_dock
        add_desired_apps_to_dock
    fi

}
main



