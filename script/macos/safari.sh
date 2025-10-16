#!/usr/bin/env bash

log_section "Safari and Webkit"

log_msg "Don't send search history to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

log_msg "Allow using tab to highlight elements"
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

log_msg "Show full URL"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

log_msg "Set homepage"
defaults write com.apple.Safari HomePage -string "about:blank"

log_msg "Don't open downloaded files automatically"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

log_msg "Hide favorites bar"
defaults write com.apple.Safari ShowFavoritesBar -bool false

log_msg "Hide sidebar"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

log_msg "Disable thumbnail cache"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

log_msg "Enable debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

log_msg "Search feature matches any part of word"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

log_msg "Remove unneeded icons from bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

log_msg "Enable developer options"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

log_msg "Enable spell check"
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

log_msg "Disable auto-correct"
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

log_msg "Disable auto-fill addressess"
defaults write com.apple.Safari AutoFillFromAddressBook -bool false

log_msg "Disable auto-fill passwords"
defaults write com.apple.Safari AutoFillPasswords -bool false

log_msg "Disable auto-fill credit cards"
defaults write com.apple.Safari AutoFillCreditCardData -bool false

log_msg "Disable auto-fill misc forms"
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

log_msg "Enable fraud warnings"
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

log_msg "Disable web plugins"
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

log_msg "Disable Java"
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

log_msg "Prevent pop-ups"
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

log_msg "Dissallow auto-play"
defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false

log_msg "Use Do not Track header"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

log_msg "Don't auto-update Extensions"
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool false

