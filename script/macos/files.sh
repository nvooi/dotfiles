#!/usr/bin/env bash

log_section "Opening, Saving and Printing Files"

log_msg "Set scrollbar to always show"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

log_msg "Set sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

log_msg "Set toolbar title rollover delay"
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

log_msg "Set increased window resize speed"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.05

log_msg "Set file save dialog to expand to all files by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

log_msg "Set print dialog to expand to show all by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

log_msg "Set files to save to disk, not iCloud by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

log_msg "Set printer app to quit once job is completed"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

log_msg "Disables the app opening confirmation dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

log_msg "Show ASCII control characters using caret notation in text views"
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

