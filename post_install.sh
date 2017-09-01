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

declare -r APPLE_SCRIPTS="./support/scripts/apple_scripts/"
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
     Usage: $PROGRAM 
            [ --make-dirs (--run-homebrew [--work | --home ])  --setup-shell --set-defaults ] | --help
     
            --help                HELP: displays this usage page
    
            --make-dirs           set up default folder structure
    
            --setup-shell         setup shell (oh-my-zsh, themes, etc.)
    
            --set-defaults        set system defaults (\"hacker\" scripts, dock init, etc.)
            
            --run-homebrew        install home brew and install apps from dump file
            
            --work                use Brewfile.development to install applications (for work computer)
            
            --home                use Brewfile.home to install applications (for home computer)
                        
     
     Need more info on this documentation? Visit http://docopt.org
    
    -----------------------------------------------------------------------------------------------------"
}


#######################################################################################################
#######################################################################################################
# helper functions ####################################################################################
#######################################################################################################
#######################################################################################################
function create_macos_popup(){
    log_func "${FUNCNAME[0]}"
    
    local -r message="$1"
    osascript -e "tell app \"System Events\" to display dialog \"$message\""
}


function authenticate_sudo(){
    log_func "${FUNCNAME[0]}"
    # Ask for the administrator password upfront.
    sudo --validate
}


#######################################################################################################
#######################################################################################################
# logging #############################################################################################
#######################################################################################################
#######################################################################################################

function log(){
    local -r msg="$1"
    echo "$PROGRAM ======================> LOG: $msg"
}

function error_log(){
    local -r msg="$1"
    log "ERROR: $msg"
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
    local is_setup_shell="false"
    local is_set_defaults="false"
    local is_help="false"
    local is_brew_work="false"
    local is_brew_home="false"
    
    
    
    local OPTS=$(getopt -o dish --long ,make-dirs,run-homebrew,setup-shell,set-defaults,work,home,help -- "$@");
    eval set -- "$OPTS";
    while true ; do
        case "$1" in
            --make-dirs) 
                is_setup_folder_structure="true"
                shift 1;
                ;;
            --run-homebrew)
                is_run_homebrew="true"
                shift 1;
                ;;
            --setup-shell)
                is_setup_shell="true"
                shift 1;
                ;;
            --set-defaults)
                is_set_defaults="true"
                shift 1;
                ;;
            --work)
                is_brew_work="true"
                shift 1;
                ;;
            --home)
                is_brew_home="true"
                shift 1;
                ;;
            --help)
                is_help="true"
                shift 1;
                ;;
            *)
                break;
                ;;
        esac
    done;
    
    
    readonly IS_SETUP_FOLDER_STRUCTURE="$is_setup_folder_structure"
    readonly IS_RUN_HOMEBREW="$is_run_homebrew"
    readonly IS_SETUP_SHELL="$is_setup_shell"
    readonly IS_SET_DEFAULTS="$is_set_defaults"
    readonly IS_HELP="$is_help"
    readonly IS_BREW_WORK="$is_brew_work"
    readonly IS_BREW_HOME="$is_brew_home"
}


function bad_input_handler(){
    local -r message="$1"

    error_log "$message"
    error_log "exiting this script!"
    usage
    exit 1
}


function validate_input(){
    if [[ "$IS_RUN_HOMEBREW" == "true" ]]; then
        if [[ "$IS_BREW_WORK" == "true" && "$IS_BREW_HOME" == "true" ]]; then
            bad_input_handler "cannot use --work and --home together"
        fi
            
        if [[ "$IS_BREW_WORK" == "false" && "$IS_BREW_HOME" == "false" ]]; then
            bad_input_handler "must give --work **OR** --home "
        fi
    fi
    
    
    if [[ "$IS_RUN_HOMEBREW" == "false" && ("$IS_BREW_WORK" == "true" || "$IS_BREW_HOME" == "true")  ]]; then
        bad_input_handler "cannot use --work or --home without --run-homebrew"
    fi
        
    if [[ "$IS_RUN_HOMEBREW" == "true" ]]; then
        if [[ "$IS_BREW_WORK" == "true" && "$IS_BREW_HOME" == "true" ]]; then
            bad_input_handler "cannot use --work and --home together"
        fi
         
         if [[ "$IS_BREW_WORK" == "false" && "$IS_BREW_HOME" == "false" ]]; then
            bad_input_handler "must give --work **OR** --home "
        fi
    fi
}





#######################################################################################################
#######################################################################################################
# create the folder structure #########################################################################
#######################################################################################################
#######################################################################################################
function setup_folder_structure(){
    log_func "${FUNCNAME[0]}"
    
    local -r documents="$HOME/Documents"
    
    mkdir -p "$documents/App_Data/1Password"
    mkdir -p "$documents/App_Data/Alfred"
    mkdir -p "$documents/App_Data/Hazel"
    mkdir -p "$documents/App_Data/Home Inventory"
    mkdir -p "$documents/App_Data/Little Snitch"
    mkdir -p "$documents/App_Data/Mackup"
    mkdir -p "$documents/App_Data/nvAlt2"
    
    mkdir -p "$documents/Developer/Repositories/"
    mkdir -p "$documents/Developer/Virtual Machines/Images"
    mkdir -p "$documents/Developer/Virtual Machines/Parallels"
    mkdir -p "$documents/Developer/Virtual Machines/Veertu"
    mkdir -p "$documents/Developer/Virtual Machines/VirtualBox"
    mkdir -p "$documents/Developer/Working/"
    
    mkdir -p "$documents/DevonThink"
    
    mkdir -p "$documents/Processing"
    
    mkdir -p "$documents/Screenshots"
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
    
    local -r brewfile_path="$1"
        
    brew bundle --file="$brewfile_path"
}


function homebrew::configure_the_fuck(){
    log_func "${FUNCNAME[0]}"
    # call 'fuck' twice to auto-add it to profile
    fuck
    fuck
}

function homebrew::install_gnu_getop(){
    log_func "${FUNCNAME[0]}"
    
    brew install gnu-getopt
}

function main_homebrew(){
    log_func "${FUNCNAME[0]}"
    
    local -r brewfile_path="$1"
    
    homebrew::install
    homebrew::install_brewfile "$brewfile_path"
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
    create_macos_popup "adding dracula theme to iterm2
    manually enable it at iterm > preferences > profiles > color tabs"
    
    local -r themes_dir="$1"

    (   cd $themes_dir"/iterm" || return
        open "Dracula.itermcolors"
    )
}

# function install_dracula::slack(){
#     log_func "${FUNCNAME[0]}"
#     create_macos_popup "install dracula theme for slack manually"
#     # https://draculatheme.com/slack/
#     local -r themes_dir="$1"
#
#     (   cd $themes_dir"/slack"
#         open "Dracula.alfredappearance"
#     )
# }

function install_dracula::sublime(){
    log_func "${FUNCNAME[0]}"
    # create_macos_popup "install dracula theme for sublime text manually"
    # https://draculatheme.com/sublime/
    local -r themes_dir="$1"

    local -r theme_file="$themes_dir/sublime/Dracula.tmTheme"
    local -r packages_dir="$HOME/Library/Application Support/Sublime Text 3/Packages"

    cp "$theme_file" "$packages_dir"
}


function install_dracula::textmate(){
    log_func "${FUNCNAME[0]}"
    # https://draculatheme.com/textmate/
    local -r themes_dir="$1"
    
    create_macos_popup "install dracula theme for textmate: please complete the popups"

    (   cd "$themes_dir/textmate" || return
        open "Dracula.tmTheme"
    )
}


function get_textual_addons_path(){
    log_func "${FUNCNAME[0]}"
    
    create_macos_popup "running keyboard maestro script, do **NOT** touch the keyboard or mouse for this part"
    (   cd "$APPLE_SCRIPTS" || return
        osascript "get_textual_addons_path_in_clipboard.scpt"
    )
    echo $(pbpaste)
}


function install_dracula::textual(){
    log_func "${FUNCNAME[0]}"
    
    # https://draculatheme.com/textual/

    local -r theme_dir="$1"
    local -r addons_path=$(get_textual_addons_path)
    
    cp -r "$theme_dir/textual" "$addons_path/Styles/dracula"
    
    create_macos_popup "dracula installed for textual\nplease select the theme from the UI"
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
    install_dracula::iterm "$themes_dir"
    # install_dracula::slack $themes_dir
    install_dracula::sublime "$themes_dir"
    install_dracula::textmate "$themes_dir"
    install_dracula::textual "$themes_dir"
    install_dracula::zsh "$themes_dir"
    
     
}


function shell::iterm_integration(){
    log_func "${FUNCNAME[0]}"
    
    local -r url="https://iterm2.com/misc/install_shell_integration.sh"
    curl -L "$url" | bash
}


function main_shell(){
    log_func "${FUNCNAME[0]}"
    
    shell:set_zsh_default
    shell::install_oh_my_zsh
    shell::iterm_integration
    homebrew::configure_the_fuck
}




#######################################################################################################
#######################################################################################################
# other ###############################################################################################
#######################################################################################################
#######################################################################################################

function restore_mackup(){
    log_func "${FUNCNAME[0]}"
    
    mackup restore
}

function pull_submodules(){
    log_func "${FUNCNAME[0]}"
    
    git submodule update --init --recursive
}


function main_defaults(){
    log_func "${FUNCNAME[0]}"
    
    pull_submodules
    setup_hacker_defaults
    dock::clear
    dock::add_apps
    install_dracula
}


#######################################################################################################
#######################################################################################################
# arq cli install and restore #########################################################################
#######################################################################################################
#######################################################################################################

# function arq::retrieve_restore_binary(){
#     log_func "${FUNCNAME[0]}"
#     (   cd "$HOME/Downloads" || return
#         local -r zip_name="arq_restore.zip"
#         wget "https://arqbackup.github.io/arq_restore/$zip_name"
#         open "$zip_name"
#
#
#     )
# }
#
# function arq::restore_from_backup(){
#     log_func "${FUNCNAME[0]}"
# #
# }





#######################################################################################################
#######################################################################################################
# main and init #######################################################################################
#######################################################################################################
#######################################################################################################
function initialize(){
    log_func "${FUNCNAME[0]}"
    
    authenticate_sudo
    
    # need gnu-getopts to parse the long arguments
    if [[ $(which brew | grep "not") ]]; then
        log "installing homebrew (required to parse long arguments)"
        homebrew::install
    else
        log "homebrew already installed"
    fi
    
    if [[ $(brew list | grep "gnu-getopt") ]]; then
        log "gnu-getopts already installed"
    else
        log "installing gnu-getopt (required to parse long arguments)"
        homebrew::install_gnu_get_opts
    fi
        
    read_parameters $ARGS
    
    validate_input
    
    exit
    if [[ "$IS_HELP" == "true" ]]; then
        usage
        exit 0
    fi
}


function main(){
    log_func "${FUNCNAME[0]}"
    
    initialize
    
    if [[ "$IS_SETUP_FOLDER_STRUCTURE" == "true" ]]; then
        log "setup folder structure"
        setup_folder_structure
    fi
    
    if [[ "$IS_RUN_HOMEBREW" == "true" && "$IS_WORK" == "true" ]]; then
        log "run homebrew / install applications"
        main_homebrew "./support/resources/brew/Brewfile.work"
    fi
    
    if [[ "$IS_RUN_HOMEBREW" == "true" && "$IS_HOME" == "true" ]]; then
        log "run homebrew / install applications"
        main_homebrew "./support/resources/brew/Brewfile.home"
    fi

    if [[ "$IS_SETUP_SHELL" == "true" ]]; then
        log "setup shell (zsh, etc.)"
        main_shell
    fi
    
    if [[ "$IS_SET_DEFAULTS" == "true" ]]; then
        log "set system defaults"
        main_defaults
    fi

}
main



