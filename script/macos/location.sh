#!/usr/bin/env bash

log_section "Local Preferences"

log_msg "Set language to English"
defaults write NSGlobalDomain AppleLanguages -array "en"

log_msg "Set locale to Ukraine"
defaults write NSGlobalDomain AppleLocale -string "uk_UA@currency=UAH"

log_msg "Set units to metric"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

