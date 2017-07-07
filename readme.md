#Clean Install Preparation
1. Run `setup.sh` in `mac-os-reinstallation-script`
2. Index applicable folders on DevonThink
2. Run sync'ing
    * 1Password
    * DevonThink
    * Hazel
3. Preference backup
    * Run mackup (should handle everything) but...
    * Little Snitch (needs done manually)
    * BetterTouchTool, Alfred, Hazel (should auto-sync, double check this is done)
4. Run Arq backups (to local and remote)



#Reinstall Preperation

1. `cd Downloads`
2. `curl https://raw.githubusercontent.com/joshS314159/mac-os-reinstallation-script/master/install.sh > .`
3. `bash install.sh`