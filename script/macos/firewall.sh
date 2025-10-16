#!/usr/bin/env bash

log_section "Firewall Config"

# Prevent automatically allowing incoming connections to signed apps
log_msg "Prevent automatically allowing incoming connections to signed apps"
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false

# Prevent automatically allowing incoming connections to downloaded signed apps
log_msg "Prevent automatically allowing incoming connections to downloaded signed apps"
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false

# Enable application firewall
log_msg "Enable application firewall"
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true
defaults write com.apple.security.firewall EnableFirewall -bool true

# Turn on firewall logging
log_msg "Turn on firewall logging"
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true

# Turn on stealth mode
log_msg "Turn on stealth mode"
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
defaults write com.apple.security.firewall EnableStealthMode -bool true

# Will prompt user to allow network access even for signed apps
log_msg "Prevent signed apps from being automatically whitelisted"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off

# Will prompt user to allow network access for downloaded apps
log_msg "Prevent downloaded apps from being automatically whitelisted"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off

# Sending hangup command to socketfilterfw is required for changes to take effect
log_msg "Restarting socket filter firewall"
sudo pkill -HUP socketfilterfw

# Disables Guest access to file shares over SMB
log_msg "Disables Guest access to file shares over SMB"
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO

# Disable remote login (incoming SSH and SFTP connections)
log_msg "Disable remote login (incoming SSH and SFTP connections)"
echo 'yes' | sudo systemsetup -setremotelogin off

# Disable insecure TFTP service
log_msg "Disable insecure TFTP service"
sudo launchctl disable 'system/com.apple.tftpd'

# Disable insecure telnet protocol
log_msg "Disable insecure telnet protocol"
sudo launchctl disable system/com.apple.telnetd

log_msg "Prevent auto-launching captive portal webpages"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false

