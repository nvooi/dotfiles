#!/usr/bin/env bash

log_section "Mouse and Trackpad"

log_msg "Set swipe scroll direction"
defaults write -g com.apple.swipescrolldirection -bool false

log_msg "Enable tap to click for trackpad"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

log_msg "Enable tab to click for current user"
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

log_msg "Enable tap to click for the login screen"
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

log_msg "Set hot corners for trackpad"
defaults write com.apple.dock wvous-tl-corner -int 11
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 1048576
defaults write com.apple.dock wvous-br-corner -int 5
defaults write com.apple.dock wvous-br-modifier -int 1048576
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
