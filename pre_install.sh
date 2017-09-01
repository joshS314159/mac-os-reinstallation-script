#!/bin/bash

set -e          # exit all shells if script fails
set -u          # exit script if uninitialized variable is used
set -o pipefail #exit script if anything fails in pipe
# set -x;       # debug mode


#########################
# GLOBALS ###############
#########################
# declare -r FILE_NAME="$0"
# declare -r FILE_NAME=$(basename $0)
readonly PROGRAM="$0"
readonly ARGS="$@"

readonly APPLE_SCRIPTS="./support/scripts/apple_scripts/"
# declare -r BASH_SCRIPTS="./support/scripts/bash/"




#######################################################################################################
#######################################################################################################
# read paramters in ###################################################################################
#######################################################################################################
#######################################################################################################
# parse ARG flags into readonly global variables
function read_parameters(){
    log_func "${FUNCNAME[0]}"
    
    local -r args="$@";
    
    local is_dump_homebrew="false"
    local is_run_mackup="false"
    local is_run_arq="false"
    local is_update_devonthink="false"
    local is_help="false"

    local OPTS=$(getopt -o dish --long ,dump-homebrew,backup-mackup,run-arq,update-devonthink,help -- "$@");
    eval set -- "$OPTS";
    while true ; do
        case "$1" in
            --dump-homebrew) 
                is_dump_homebrew="true"
                shift 1;
                ;;
            --backup-mackup)
                is_run_mackup="true"
                shift 1;
                ;;
            --run-arq)
                is_run_arq="true"
                shift 1;
                ;;
            --update-devonthink)
                is_update_devonthink="true"
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

    # CREATES GLOBAL VARIABLES #####################
    readonly IS_DUMP_HOMEBREW="$is_dump_homebrew"
    readonly IS_RUN_MACKUP="$is_run_mackup"
    readonly IS_RUN_ARQ="$is_run_arq"
    readonly IS_UPDATE_DEVONTHINK="$is_update_devonthink"
    readonly IS_HELP="$is_help"
    # CREATES GLOBAL VARIABLES #####################
}




#######################################################################################################
#######################################################################################################
# logging #############################################################################################
#######################################################################################################
#######################################################################################################

function log(){
    local -r msg="$1"
    echo "$PROGRAM ===========> LOG: $msg"
}

function log_func(){
    local -r function_name="$1"
    log "function - $function_name"
}



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
            [--dump-homebrew --backup-mackup --run-arq --update-devonthink] | --help

        --help                  HELP: displays this usage page

        --dump-homebrew         dumps homebrew information (installed apps) to Brewfile.dump

        --backup-mackup         run \`mackup backup\` to update backed up preference files

        --run-arq               run arq backup

        --update-devonthink     index and sync DevonThink

        
        
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
# # dumps all installed homebrew stuff into a Brewfile ################################################
#######################################################################################################
#######################################################################################################
function dump_homebrew(){
    log_func "${FUNCNAME[0]}"
    
    local -r dump_location="./support/resources/brew/Brewfile.dump"
    brew bundle dump --force --file="$dump_location"
}


#######################################################################################################
#######################################################################################################
# run devonthink index and sync apple scripts #########################################################
#######################################################################################################
#######################################################################################################

function index_and_sync_devonthink(){
    log_func "${FUNCNAME[0]}"
    (   cd "$APPLE_SCRIPTS" || return
        osascript "index_devonthink.scpt"
        osascript "sync_devonthink.scpt"
    )
}


#######################################################################################################
#######################################################################################################
# links any new apps to have pref files sym linked ####################################################
#######################################################################################################
#######################################################################################################
function backup_mackup(){
    log_func "${FUNCNAME[0]}"
    mackup backup
}




#######################################################################################################
#######################################################################################################
# run arq backup ######################################################################################
#######################################################################################################
#######################################################################################################
function backup_arq(){
    log_func "${FUNCNAME[0]}"
    
    (   cd "/Applications/Arq.app/Contents/MacOS" || return
    
        create_macos_popup "The following two dialogs will prompt to backup with Arq.
        1. Select Backblaze B2
        2. Select 10.0.1.8 to back up to the local Synology NAS
            If remote, ensure VPN in enabled"
            
        # select B2
        ./Arq backupnow
    
        # select local
        ./Arq backupnow
    )
}


#######################################################################################################
#######################################################################################################
# main and init #######################################################################################
#######################################################################################################
#######################################################################################################

function initialize(){
    log_func "${FUNCNAME[0]}"
    read_parameters $ARGS
    
    if [[ "$IS_HELP" == "true" ]]; then
        usage
        exit 0
    fi
    
    authenticate_sudo
    
}

function main(){
    log_func "${FUNCNAME[0]}"

    initialize
    
    if [[ "$IS_DUMP_HOMEBREW" == "true" ]]; then
        log "dump homebrew"
        dump_homebrew
    fi
    
    if [[ "$IS_RUN_MACKUP" == "true" ]]; then
        log "backup mackup"
        backup_mackup
    fi
    
    if [[ "$IS_UPDATE_DEVONTHINK" == "true" ]]; then
        log "index and sync devonthink"
        index_and_sync_devonthink
    fi
    
    if [[ "$IS_RUN_ARQ" == "true" ]]; then
        log "backup arg"
        backup_arq
    fi
}
main




