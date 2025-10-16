#!/usr/bin/env bash

log_section "Account Security"

# Enforce system hibernation
log_msg "Enforce hibernation instead of sleep"
sudo pmset -a destroyfvkeyonstandby 1

# Require a password to wake the computer from sleep or screen saver
log_msg "Require a password to wake the computer from sleep or screen saver"
sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -bool true

# Initiate session lock five seconds after screen saver is started
log_msg "Initiate session lock five seconds after screen saver is started"
sudo defaults write /Library/Preferences/com.apple.screensaver 'askForPasswordDelay' -int 5

# Disables signing in as Guest from the login screen
log_msg "Disables signing in as Guest from the login screen"
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO

# Disables Guest access to file shares over AF
log_msg "Disables Guest access to file shares over AF"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO

