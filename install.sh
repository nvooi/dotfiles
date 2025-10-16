#!/usr/bin/env bash

# -------------------------------------------
# Dotfiles Installation Script
# -------------------------------------------
#
# Description: This script installs or updates dotfiles from a specified
#              Git repository, and ensures required dependencies are installed
#              based on the system's OS type.
#
# Maintainer:  nvooi <nvooito@gmail.com>
# Repository:  https://github.com/nvooi/dotfiles
# License:     MIT
#
# Usage:
#   ./install.sh [--auto-confirm] [--help]
#
# Options:
#   --auto-confirm   Skip the interactive confirmation prompt.
#   --help           Display usage/help message and exit.
#
# -------------------------------------------

# --------- Core Dependencies List -----------

CORE_DEPENDENCIES=(
	'git'
	'vim'
	'zsh'
)

# --------- Repository Settings --------------

REPOSITORY_LOCAL_DIR="${REPOSITORY_LOCAL_DIR:-$HOME/Projects/dotfiles}"
REPOSITORY_URL="${REPOSITORY_URL:-https://github.com/nvooi/dotfiles}"

# --------- Predefined Escape Codes ----------

EC_PURPLE='\033[0;35m'
EC_YELLOW='\033[0;93m'
EC_LIGHT='\x1b[2m'
EC_RESET='\033[0m'

# --------- Script Behaviour Functions -------

# Show script introduction
function print_usage() {
	echo -e "\n${EC_PURPLE}Dotfiles Installation Script${EC_RESET}\n"
	echo -e "This script will install or update specified dotfiles:\n\
	${EC_PURPLE}- From: ${EC_YELLOW}${REPOSITORY_URL}${EC_RESET}\n\
	${EC_PURPLE}- Into: ${EC_YELLOW}${REPOSITORY_LOCAL_DIR}${EC_RESET}\n"
	echo -e "${EC_PURPLE}${EC_LIGHT}This script will attempt to install required packages"\
	"based on your operating system. Elevated permissions may be required."\
	"\nPlease review the script before proceeding.\n${EC_RESET}"
}

# Ask user if they want to proceed
function confirm_proceeding() {
	if [[ ! $* == *"--auto-confirm"* ]]; then
		echo -e "${EC_PURPLE}Would you like to continue? (y/N)${EC_RESET}"
		read -t 60 -n 1 -r && echo

		if [[ ! $REPLY =~ ^[Yy]$ ]]; then
			echo -e "${EC_YELLOW}Proceeding was rejected by user.${EC_RESET}"
			exit 0
		fi
	fi
}

# --------- MacOS Helpers ---------------------

# Install CLI Tools on macOS
function install_mac_cli_tools () {
    echo -e "${EC_PURPLE}Installing macOS CLI Tools.${EC_RESET}"
	xcode-select --install >/dev/null 2>&1

	# Wait untill installation process is finished
	until xcode-select -p &>/dev/null; do
		sleep 5
	done

	# Path to Xcode if installed
	local x=$(find '/Applications' -maxdepth 1 -regex '.*/Xcode[^ ]*.app' -print -quit)
	local d="${x}/Contents/Developer"

	if [ -d "$d" ]; then
		sudo xcode-select -s "$d"
	fi

	if /usr/bin/xcrun clang &> /dev/null; then
    	sudo xcodebuild -license accept
	fi
}

# Install Homebrew on macOS
function install_homebrew () {
	echo -e "${EC_PURPLE}Installing Homebrew...${EC_RESET}"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# --------- Dependencies Install Functions ----

# Install a core dependency using APT (Debian/Ubuntu)
function install_core_dependency_debian () {
	echo -e "${EC_PURPLE}Installing ${1} via apt...${EC_RESET}"
	sudo apt update && sudo apt install -y "$1"
}

# Install a core dependency using Homebrew (macOS)
function install_core_dependency_macos () {
	echo -e "${EC_PURPLE}Installing ${1} via brew...${EC_RESET}"
	brew install "$1"
}

# Install a core dependency, OS agnostic
function install_core_dependency () {
	dependency=$1

	if [ -f "/etc/debian_version" ] && hash apt 2> /dev/null; then
		install_core_dependency_debian "$dependency"

	elif [ "$(uname -s)" = "Darwin" ]; then
	export PATH="/opt/homebrew/bin:$PATH"
    	if ! xcode-select -p &>/dev/null; then install_mac_cli_tools; fi
		if ! hash brew 2> /dev/null; then install_homebrew; fi
		install_core_dependency_macos "$dependency"

	else
		echo -e "${EC_YELLOW}Unsupported OS type. Exiting!${EC_RESET}"
		exit 1
	fi
}

# Install all core dependencies
function install_all_core_dependencies () {
	for dependency in "${CORE_DEPENDENCIES[@]}"; do
		if ! hash "$dependency" 2> /dev/null; then
			install_core_dependency "$dependency"
		else
			echo -e "${EC_YELLOW}${dependency} is already installed.${EC_RESET}"
		fi
	done
}

# --------- Repo Helper Functions ------------

# Clone dotfiles repository
function clone_dotfiles_repository () {
	if [[ ! -d "$REPOSITORY_LOCAL_DIR" ]]; then
		echo -e "${EC_PURPLE}Cloning dotfiles repository...${EC_RESET}"
		mkdir -p "${REPOSITORY_LOCAL_DIR}" && \
			git clone --recursive "${REPOSITORY_URL}" "${REPOSITORY_LOCAL_DIR}"
	else
		echo -e "${EC_YELLOW}Repository already exists at ${REPOSITORY_LOCAL_DIR}.${EC_RESET}"
	fi
}

# Execute setup script from the repository
function execute_repository_setup_script () {
	if [[ -f "${REPOSITORY_LOCAL_DIR}/setup.sh" ]]; then
		cd "${REPOSITORY_LOCAL_DIR}" &&                         \
			chmod +x ./setup.sh &&                              \
			./setup.sh                                          \
                REPOSITORY_LOCAL_DIR="${REPOSITORY_LOCAL_DIR}"  \
                REPOSITORY_URL="${REPOSITORY_URL}"              \
                --no-clear 

	else
		echo -e "${EC_YELLOW}setup.sh not found in ${REPOSITORY_LOCAL_DIR}.${EC_RESET}"
	fi
}

# --------- Run the Script -------------------

print_usage
if [[ $* == *"--help"* ]]; then exit 0; fi

confirm_proceeding "$@"
install_all_core_dependencies

clone_dotfiles_repository
execute_repository_setup_script

echo -e "\n${EC_PURPLE}All done. Exiting!${EC_RESET}\n"
exit 0

