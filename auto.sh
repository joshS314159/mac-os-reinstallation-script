#!/bin/bash

set -o pipefail


#########################
# GLOBALS ###############
#########################
declare -r FILE_NAME="$0"

declare BEFORE="false"
declare AFTER="false"



#########################
# PARAMETERS ############
#########################

args=`getopt abo: $*`
    # you should    not use `getopt abo: "$@"` since that would parse
    # the arguments differently from what the set command below does.
    if [    $? -ne 0 ]; then
       echo 'Usage: ...'
       exit 2
    fi
    set -- $args
    # You cannot use the set command with a backquoted getopt directly,
    # since the exit code from getopt would be shadowed by those    of set,
    # which is zero by definition.
    while :; do
       case "$1" in
       -a)
           AFTER=true
           shift
           ;;
       -b)
           BEFORE=true
           shift
           ;;
       --)
           shift; break
           ;;
       esac
    done

declare -r BEFORE
declare -r AFTER



logic::before(){
    
    # run devonthink index and sync apple scripts
    function index_and_sync_devonthink(){
        (   cd $(pwd)"/support/scripts/apple_scripts/"
            osascript "index_devonthink.scpt"
            osascript "sync_devonthink.scpt"
        )
    }


    # links any new apps to have pref files sym linked
    function backup_mackup(){
        mackup backup
    }


    # dumps all installed homebrew stuff into a Brewfile
    function dump_homebrew(){
        brew bundle dump --force --file="$(pwd)/support/resources/brew/Brewfile"
    }

    
    # run arq backup
    function backup_arq(){
        (
            cd "/Applications/Arq.app/Contents/MacOS"
        
            # select B2
            ./Arq backupnow
        
            # select local
            ./Arq backupnow
        )
    }


    function main(){
        echo "RUNNING BEFORE"
        
        index_and_sync_devonthink
    
        dump_homebrew
    
        # backup_mackup
        backup_arq
    }
    main
}


logic::after(){
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



    function setup_folder_structure(){
        mkdir -p "~/Documents/Developer/Repositories/"
        mkdir -p "~/Documents/Developer/Virtual Machines/"
        mkdir -p "~/Documents/Developer/Working/"
    
        mkdir -p "~/Documents/DevonThink"
        
        mkdir -p "~/Documents/1Password"
        mkdir -p "~/Documents/DevonThink"
        mkdir -p "~/Documents/nvAlt2"
        mkdir -p "~/Documents/ScanSnap Processing"
    }



    declare -r url_app_dir="~/Downloads/url_apps"
    declare -r url_apps=(
      # "https://pqrs.org/latest/karabiner-elements-latest.dmg"
      "http://www.fujitsu.com/global/support/products/computing/peripheral/scanners/scansnap/software/s1300m-setup.html"
    )

    declare -r do_repos_stuff_manually=true
    declare -r repo_stuff_dir="~/Documents/Repositories"
    declare -r repo_stuff=(
      # my repo
      "https://github.com/joshS314159/mac-os-reinstallation-script.git"
    )




    function init_homebrew(){
        # INSTALL HOMEBREW
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

        # TAP HOMEBREW BUNDLER AND INSTALL
        brew tap homebrew/bundle

        # CAT CUSTOM FILE WITH AUTOGEN FILE
        cat "./BrewfileCustom" >> "Brewfile"
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
    
    
    function setup_hacker_defaults(){
        (   cd $(pwd)"/support/scripts/bash/"
            bash "mac_os_for_hackers.sh"
        )
    }


    function main(){
        echo "RUNNING AFTER"
        init_homebrew

        install_from_homebrew
        install_from_url
        install_from_repo
        
        setup_hacker_defaults

        init_cli
    }
    main
    # 

}



function main(){
    if [[ "$BEFORE" == "true" ]]; then
        logic::before
    elif [[ "$AFTER" == "true" ]]; then
        logic::after
    else
        echo "bad!"
    fi
}

main



