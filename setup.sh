#!/bin/bash


function index_devonthink(){
    (
        cd $(pwd)"/support/apple_scripts/"
        osascript "index_devonthink.scpt"
    )
}


function backup_mackup(){
    mackup backup
}


function homebrew_setup(){
    brew bundle dump --force --file="$(pwd)/Brewfile"
}


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
    index_devonthink
    
    homebrew_setup
    
    backup_mackup
    backup_arq
}
main


