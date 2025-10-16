#!/usr/bin/env bash

log_section "System Power and Lock Screen"

log_msg "Prevent automatic restart when power restored"
sudo pmset -a autorestart 1

log_msg "Set display to sleep after 15 minutes"
sudo pmset -a displaysleep 15

log_msg "Set sysyem sleep time to 30 minutes when on battery"
sudo pmset -b sleep 30

log_msg "Set system to not sleep automatically when on mains power"
sudo pmset -c sleep 0

log_msg "Require password immediately after sleep or screensaver"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

log_msg "Disable system wide resuming of windows"
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

log_msg "Disable auto termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

log_msg "Disable the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none"

log_msg "Add host info to the login screen"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

