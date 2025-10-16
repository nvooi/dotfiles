#!/usr/bin/env bash

log_section "UI Settings"

# Set highlight color
log_msg "Set text highlight color"
defaults write NSGlobalDomain AppleHighlightColor -string "${HIGHLIGHT_COLOR:-0 0.8 0.7}"

log_msg "Hide menu bar"
defaults write NSGlobalDomain _HIHideMenuBar -bool true

log_msg "Enable HiDPI display modes"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

log_msg "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 1

