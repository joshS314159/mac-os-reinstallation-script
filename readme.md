# Requirements

* macOS
* [gnu-getopt](http://brewformulas.org/Gnu-getopt)
* [Mackup](https://github.com/lra/mackup)


# Before Reinstallation
1. Run ```bash pre_install.sh --dump-homebrew ----backup-mackup --run-arq ----update-devonthink` in `mac-os-reinstallation-script```
2. Manually run sync'ing
    * 1Password
    * Hazel
    * Alfred
3. Manual preference backup
    * Little Snitch
    * BetterTouchTool
4. Verify Arq backups are complete



# What's where

* Applications: Homebrew via Brewfile dump

* Documents: in Devonthink, sync'd with Dropbox

* Preferences/dotfiles: [Mackup](https://github.com/lra/mackup)

* Non-config file (system) preferences: `<repo>/support/scripts/bash/mac_os_for_hackers.sh`
    *  There are tons of these around the web. For more config support/ideas/etc., Google "mac os for hackers"

* Passwords: [1Password (standalone)](https://1password.com) via Dropbox

* Photos: iCloud/Photos.app

* Music: iTunes Match / Apple Music

* Code: Github

* $HOME: backed up with Arq to multiple locations (NAS, Google Drive, Dropbox, Backblaze)


# After Reinstallation

1. `cd Downloads`
2. `git clone --recursive -j8 https://github.com/joshS314159/mac-os-reinstallation-script.git`
3. Make your decisions based on `bash ./mac-os-reinstallation-script/post_install.sh --help` and run
4. Log into Dropbox


# Todo

Create private/encrypted/well-protected "config" file with information required to restore files from backup

