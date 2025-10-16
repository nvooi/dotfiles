#!/usr/bin/env bash

log_section "Finder"

log_msg "Open new tabs to Home"
defaults write com.apple.finder NewWindowTarget -string "PfHm"

log_msg "Open new windows to file root"
defaults write com.apple.finder NewWindowTargetPath -string "file:///"

log_msg "Show hidden files"
defaults write com.apple.finder AppleShowAllFiles -bool true

log_msg "Show file extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

log_msg "View all network locations"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

log_msg "Show the ~/Library folder"
chflags nohidden ~/Library

log_msg "Show the /Volumes folder"
chflags nohidden /Volumes

log_msg "Allow finder to be fully quitted with ? + Q"
defaults write com.apple.finder QuitMenuItem -bool true

log_msg "Show the status bar in Finder"
defaults write com.apple.finder ShowStatusBar -bool true

log_msg "Show the path bar in finder"
defaults write com.apple.finder ShowPathbar -bool true

log_msg "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

log_msg "Expand the General, Open and Privileges file info panes"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

log_msg "Keep directories at top of search results"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

log_msg "Search current directory by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

log_msg "Don't show warning when changing extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

log_msg "Don't add .DS_Store to network drives"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

log_msg "Don't add .DS_Store to USB devices"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

log_msg "Open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true

log_msg "Open a new Finder window when a disk is mounted"
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

log_msg "Show item info"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

log_msg "Enable snap-to-grid for icons on the desktop and finder"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

log_msg "Set grid spacing for icons on the desktop and finder"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

log_msg "Set icon size on desktop and in finder"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

