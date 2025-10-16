#!/usr/bin/env bash

log_section "Sound and Display"

log_msg "Increase sound quality for Bluetooth devices"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
