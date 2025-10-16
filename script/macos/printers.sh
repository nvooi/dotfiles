#!/usr/bin/env bash

log_section "Printers and Sharing Protocols"

# Disable sharing of local printers with other computers
log_msg "Disable sharing of local printers with other computers"
cupsctl --no-share-printers

# Disable printing from any address including the Internet
log_msg "Disable printing from any address including the Internet"
cupsctl --no-remote-any

# Disable remote printer administration
log_msg "Disable remote printer administration"
cupsctl --no-remote-admin

# Disable Captive portal
log_msg "Disable Captive portal"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false

