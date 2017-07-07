#!/bin/bash


function backup_arq(){
    (
        cd "/Applications/Arq.app/Contents/MacOS"
        
        # select B2
        ./Arq backupnow
        
        # select local
        ./Arq backupnow
    )
}


function backup_mackup(){
    mackup backup
}


function homebrew_setup(){
    brew bundle dump --force --file="$(pwd)/Brewfile"
}


function main(){
    backup_mackup
    
    homebrew_setup
    
    backup_arq
}
main


