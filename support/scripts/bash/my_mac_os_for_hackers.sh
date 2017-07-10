#!/bin/bash

# set -o pipefail


###############################################################################
# General UI/UX                                                               #
###############################################################################

# >>>> enable dark mode
# 1. enable hot key
sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
# 2. trigger hot key

# 3. disable hot key