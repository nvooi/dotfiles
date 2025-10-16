#!/usr/bin/env bash

# --------------------------------------------
# Dotfiles Setup Script
# --------------------------------------------
#
# --------------------------------------------

# --------- Repository Settings --------------

REPOSITORY_LOCAL_DIR="${REPOSITORY_LOCAL_DIR:-$HOME/Projects/dotfiles}"
REPOSITORY_URL="${REPOSITORY_URL:-https://github.com/nvooi/dotfiles}"

# --------- System Settings ------------------

SOURCE_DIR=$(dirname ${0})
CURRENT_DIR=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)
SYSTEM_TYPE=$(uname -s)
START_TIME=`date +%s`

# --------- Predefined Escape Codes ----------

EC_RED='\033[1;31m'
EC_GREEN='\033[1;32m'
EC_PURPLE='\033[0;35m'
EC_YELLOW='\033[0;93m'
EC_CYAN='\033[0;96m'
EC_LIGHT='\x1b[2m'
EC_RESET='\033[0m'

# --------- Script Usage ---------------------

# Show script introduction
function print_usage() {
	echo -e "\n${EC_PURPLE}Dotfiles Setup Script${EC_RESET}\n"
}

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
		read -t 60 -n 1 -r && echo -e "\n"

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

    if [ "${SYSTEM_TYPE}" = "Darwin" ]; then
        export PATH="/opt/homebrew/bin:$PATH"
        ensure_command_available "brew" true
    fi

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

# --------- Installing Configs ---------------

function make_soft_link () {
    local target="$1"
    local source="$2"
    
    echo -e "${EC_GREEN}[INFO]: Linking $target -> $source${EC_RESET}"
    mkdir -p "$(dirname $target)"
    
    if [[ -f "$PWD/$source" || -d "$PWD/$source" ]]; then
        ln -sf "$PWD/$source" "$target"
    fi

}

function install_configs () {
    # Pull repo
    
    if [[ ! -d "${REPOSITORY_LOCAL_DIR}" ]]; then
        echo -e "${EC_RED}[ERROR]: Dotfiles repo ${REPOSITORY_LOCAL_DIR} not present.${EC_RESET}"
        terminate
    else
        echo -e "${EC_GREEN}[INFO]: Pulling latest changes from ${REPOSITORY_URL}.${EC_RESET}"
        cd "${REPOSITORY_LOCAL_DIR}" && git pull origin main
    fi
    
    # Symlinks

    echo -e "${EC_GREEN}[INFO]: Cleaning old symlinks.${EC_RESET}"
    rm -rf "$HOME/.zshenv" "$XDG_CONFIG_HOME"

    echo -e "${EC_GREEN}[INFO]: Settings up symlinks.${EC_RESET}"
    make_soft_link "$XDG_CONFIG_HOME/nvim" "config/nvim"

    echo 
}

# --------- Installing Packages --------------

function install_macos_packages () {
    if ! is_command_available "brew"; then
        echo -e "${EC_YELLOW}[WARNING]: Homebrew is not installed!${EC_RESET}"
        return
    fi

    local f="${REPOSITORY_LOCAL_DIR}/install/brew/Brewfile"

    if [ -f "${f}" ]; then
        echo -e "${EC_GREEN}[INFO]: Updating Homebrew and packages.${EC_RESET}"
        brew update && brew upgrade && brew bundle --file "${f}"
        brew cleanup
        killall Finder
    else
        echo -e "${EC_YELLOW}[WARNING]: Brewfile not found!${EC_RESET}"
    fi
}

function install_packages () {
    echo -en "${EC_CYAN}Would you like to install system packages? (y/N)${EC_RESET}\n"
    read -t 60 -n 1 -r ans && echo -e "\n"

    if [[ ! $ans =~ ^[Yy]$ ]]; then
        echo -e "${EC_YELLOW}[WARNING]: Skipping system packages installation.${EC_RESET}"
        return
    fi

    if [ "${SYSTEM_TYPE}" = "Darwin" ]; then
        install_macos_packages
    else
        echo -e "${EC_RED}[ERROR]: Unsupported OS type!${EC_RESET}"
        terminate
    fi
}

# --------- Run the Script -------------------

print_usage
if [[ $* == *"--help"* ]]; then exit 0; fi

confirm_proceeding "$@"
prepare_setup

install_configs
install_packages

