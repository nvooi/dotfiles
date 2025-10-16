#!/usr/bin/env bash

log_section "Dock and Launchpad"

log_msg "Set dock position to left-hand side"
defaults write com.apple.dock orientation -string left

log_msg "Remove default apps from the dock"
defaults write com.apple.dock persistent-apps -array

log_msg "Add highlight effect to dock stacks"
defaults write com.apple.dock mouse-over-hilite-stack -bool true

log_msg "Set item size within dock stacks"
defaults write com.apple.dock tilesize -int 48

log_msg "Set dock to use genie animation"
defaults write com.apple.dock mineffect -string "genie"

log_msg "Set apps to minimize into their dock icon"
defaults write com.apple.dock minimize-to-application -bool true

log_msg "Enable spring loading, for opening files by dragging to dock"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

log_msg "Enable process indicator for apps within dock"
defaults write com.apple.dock show-process-indicators -bool true

log_msg "Enable app launching animations"
defaults write com.apple.dock launchanim -bool true

log_msg "Set opening animation speed"
defaults write com.apple.dock expose-animation-duration -float 1

log_msg "Disable auntomatic rearranging of spaces"
defaults write com.apple.dock mru-spaces -bool false

log_msg "Set dock to auto-hide by default"
defaults write com.apple.dock autohide -bool true

log_msg "Set the dock's auto-hide delay to fast"
defaults write com.apple.dock autohide-delay -float 0.05

log_msg "Set the dock show / hide animation time"
defaults write com.apple.dock autohide-time-modifier -float 0.25

log_msg "Show which dock apps are hidden"
defaults write com.apple.dock showhidden -bool true

log_msg "Hide recent files from the dock"
defaults write com.apple.dock show-recents -bool false

log_msg "Restarting dock"
killall Dock

log_msg "Restarting system ui server"
killall SystemUIServer

