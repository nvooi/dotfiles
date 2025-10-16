#!/usr/bin/env bash

# --------- Predefined Escape Codes ----------

export EC_RED='\033[1;31m'
export EC_GREEN='\033[1;32m'
export EC_RESET='\033[0m'

# --------- Config ---------------------------

export COMPUTER_NAME="nvooi"
export HIGHLIGHT_COLOR="0 0.8 0.7"

# --------- Logging --------------------------

# Helper function to log progress to console
function log_msg () {
  CURRENT_EVENT=$(($CURRENT_EVENT + 1))
  if [[ ! $params == *"--silent"* ]]; then
    echo -e "       ${1}"
  fi
}

# Helper function to log section to console
function log_section () {
  if [[ ! $params == *"--silent"* ]]; then
    echo -e "${EC_GREEN}[INFO]: ${1}${EC_RESET}"
  fi
}

# --------- Cleanup --------------------------

function cleanup () {
    unset EC_RED
    unset EC_GREEN
    unset EC_RESET

    unset log_msg
    unset log_section
}

trap cleanup EXIT

# --------- Run the Script -------------------

# Check have got admin privilages
if [ "$EUID" -ne 0 ]; then
  echo -e "\nElevated permissions are required to adjust system settings."
  echo -e "Please enter your password:"
  script_path=$([[ "$0" = /* ]] && echo "$0" || echo "$PWD/${0#./}")
  sudo "$script_path" || (
    echo -e "${EC_RED}[ERROR]: Unable to continue without sudo permissions"
    exit 1
  )
  exit 0
fi


# Quit System Preferences before starting
osascript -e 'tell application "System Preferences" to quit'

# Keep script alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

## Call oher scrips under macos folder
cd script/macos
SCRIPTS="$(command ls -1)"

removeFromArray=install.sh
SCRIPTS=${SCRIPTS[*]/$removeFromArray/}

export -f log_msg
export -f log_section

for script in $SCRIPTS; do
  chmod +x $script && ./$script
done

