#!/usr/bin/env bash

log_section "Device Info"

# Set computer name and hostname
log_msg "Set computer name"
scutil --set ComputerName "$COMPUTER_NAME"

log_msg "Set remote hostname"
scutil --set HostName "$COMPUTER_NAME"

log_msg "Set local hostname"
scutil --set LocalHostName "$COMPUTER_NAME"

