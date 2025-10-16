#!/usr/bin/env bash

log_section "Apple Mac Store"

log_msg "Allow automatic update checks"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

log_msg "Auto install criticial security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

log_msg "Enable the debug menu"
defaults write com.apple.appstore ShowDebugMenu -bool true

log_msg "Enable extra dev tools"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

