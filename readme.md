#Before Reinstallation
1. Run `pre_install.sh -z` in `mac-os-reinstallation-script`
2. <s>Index applicable folders on DevonThink</s>
2. Run sync'ing
    * 1Password
    * <s>DevonThink</s>
    * Hazel
3. Preference backup
    * <s>Run mackup (should handle everything) but...</s>
    * Little Snitch (needs done manually)
    * BetterTouchTool, Alfred, Hazel (should auto-sync, double check this is done)
4. <s>Run Arq backups (to local and remote)</s>



# What's what

* Applications: Homebrew via Brewfile dump

* Documents: sync'd with Devonthink, backed up with Arq

* Photos: iCloud

* Music: iTunes Match / Apple Music

* Code: Github

* $HOME: backed up with Arq

* Preferences/dotfiles: Mackup

#After Reinstallation

1. `cd Downloads`
2. `git clone https://github.com/joshS314159/mac-os-reinstallation-script.git`
3. `bash ./mac-os-reinstallation-script/post_install.sh`