#!/usr/bin/env bash

# --------------------------------------------
# Dotfiles Setup Script
# --------------------------------------------
#
# --------------------------------------------

# --------- Repository Settings --------------

REPOSITORY_LOCAL_DIR="${REPOSITORY_LOCAL_DIR:-$HOME/Projects/dotfiles}"
REPOSITORY_URL="${REPOSITORY_URL:-https://github.com/nvooi/dotfiles}"

# --------- Predefined Escape Codes ----------

EC_RED='\033[1;31m'
EC_GREEN='\033[1;32m'
EC_PURPLE='\033[0;35m'
EC_YELLOW='\033[0;93m'
EC_CYAN='\033[0;96m'
EC_LIGHT='\x1b[2m'
EC_RESET='\033[0m'

# --------- Banner ---------------------------

function banner_length () {
    local text=$1
    local padding_length="${3:-0}"
    echo $(expr ${#text} + 4 + $padding_length)
}

function print_banner () {
    local text=$1
    local color="${2:-$EC_CYAN}"
    local length=$(banner_length "$@")

    local line_char="-"
    local line=""

    for (( i = 0; i < "$length"; ++i )); do
        line="${line}${line_char}"
    done

    banner="${color}${line} \n| ${EC_RESET}${text}${color} |\n${line}"
    echo -e "\n${banner}${EC_RESET}\n"
}

# --------- Script Behaviour Functions -------
#
function terminate () {
    print_banner "Setup failed. Terminating!" $EC_RED
    exit 1
}

# Show script introduction
function print_usage() {
	echo -e "\n${EC_PURPLE}Dotfiles Setup Script${EC_RESET}\n"
}

# Ask user if they want to proceed
function confirm_proceeding() {
	if [[ ! $* == *"--auto-confirm"* ]]; then
		echo -e "${EC_PURPLE}Would you like to continue? (y/N)${EC_RESET}"
		read -t 60 -n 1 -r && echo

		if [[ ! $REPLY =~ ^[Yy]$ ]]; then
			echo -e "${EC_YELLOW}[WARNING]: Proceeding was rejected by user.${EC_RESET}"
            terminate
		fi
	fi
}

function prepare_setup () {
    # Ensure required commands
    ensure_command_available "git" true
    ensure_command_available "vim" false 
    ensure_command_available "zsh" false 

    # Ensure XDG environment
    if [ -z ${XDG_CONFIG_HOME+x} ]; then
        echo -e "${EC_YELLOW}[WARNING]: XDG_CONFIG_HOME is not set. Will use ~/.config${EC_RESET}"
        export XDG_CONFIG_HOME="${HOME}/.config"
    fi
    if [ -z ${XDG_DATA_HOME+x} ]; then
        echo -e "${EC_YELLOW}[WARNING]: XDG_DATA_HOME is not set. Will use ~/.local/share${EC_RESET}"
        export XDG_DATA_HOME="${HOME}/.local/share"
    fi
}

# --------- Dependencies Helper --------------

function is_command_available() {
    hash "$1" 2> /dev/null
}

function ensure_command_available() {
    if is_command_available "$1"; then
        return
    fi

    if $2; then
        echo -e "${EC_RED}[ERROR]: $1 is not installed!${EC_RESET}"
        terminate
    else
        echo -e "${EC_YELLOW}[WARNING]: $1 is not installed!${EC_RESET}"
    fi
}

# --------- Script Usage ---------------------

# Show script introduction
function print_usage() {
	echo -e "\n${EC_PURPLE}Dotfiles Setup Script${EC_RESET}\n"
}

# --------- Run the Script -------------------

print_usage
if [[ $* == *"--help"* ]]; then exit 0; fi

confirm_proceeding "$@"
prepare_setup

