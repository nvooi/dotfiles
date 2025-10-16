#!/usr/bin/env bash

log_section "Disable Telemetry and Assistant Features"

# Disable Ask Siri
log_msg "Disable 'Ask Siri'"
defaults write com.apple.assistant.support 'Assistant Enabled' -bool false

#  Disable Siri voice feedback
log_msg "Disable Siri voice feedback"
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3

# Disable "Do you want to enable Siri?" pop-up
log_msg "Disable 'Do you want to enable Siri?' pop-up"
defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True

# Hide Siri from menu bar
log_msg "Hide Siri from menu bar"
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0

# Hide Siri from status menu
log_msg "Hide Siri from status menu"
defaults write com.apple.Siri 'StatusMenuVisible' -bool false
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true

# Opt-out from Siri data collection
log_msg "Opt-out from Siri data collection"
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2

# Dont prompt user to report crashes, may leak sensitive info
log_msg "Disable crash reporter"
defaults write com.apple.CrashReporter DialogType none

