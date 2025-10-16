#!/usr/bin/env bash

log_section "Keyboard and Input"

log_msg "Disable automatic text capitalization"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

log_msg "Disable automatic dash substitution"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

log_msg "Disable automatic periord substitution"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

log_msg "Disable automatic period substitution"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

log_msg "Disable automatic spell correction"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

log_msg "Enable full keyboard navigation in all windows"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

log_msg "Allow modifier key to be used for mouse zooming"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

log_msg "Follow the keyboard focus while zoomed in"
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

log_msg "Set time before keys start repeating"
defaults write NSGlobalDomain InitialKeyRepeat -int 50

log_msg "Set super fast key repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 8

