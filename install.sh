#!/usr/bin/env bash

# --------- Core Dependencies List ---------

CORE_DEPENDENCIES=(
	'git'
	'vim'
	'zsh'
)

# --------- Predefined Escape Codes ---------

EC_PURPLE='\033[0;35m'
EC_YELLOW='\033[0;93m'
EC_LIGHT='\x1b[2m'
EC_RESET='\033[0m'

# --------- Repository Settings ---------

REPOSITORY_LOCAL_DIR="${REPOSITORY_LOCAL_DIR:-$HOME/Projects/dotfiles}"
REPOSITORY_URL="${REPOSITORY_URL:-https://github.com/nvooi/dotfiles}"

# --------- Script Behaviour Functions ---------

# Shows script introduction
function print_usage() {
	echo -e "\n${EC_PURPLE}Dotfiles Installation Script\n"
	echo -e "This script wil install or update specified dotfiles:${EC_RESET}\n\
	${EC_PURPLE}- From: ${EC_YELLOW}${REPOSITORY_URL}${EC_RESET}\n\
	${EC_PURPLE}- Into: ${EC_YELLOW}${REPOSITORY_LOCAL_DIR}${EC_RESET}\n"
	echo -e "${EC_PURPLE}${EC_LIGHT}There's a few packages that are needed in order to continue"\
	"with setting up dotfiles. This script will detect distro and use appropriate package"\
	"manager to install apps. Elevated permissions may be required. Ensure you've read"\
	"the script before processding.\n${EC_RESET}"
}

# Ask user if they'd like to preceed
function confirm_proceeding() {
	if [[ ! $* == *"--auto-confirm"* ]]; then
		echo -e "${EC_PURPLE}Whould you like to continue? (y/N)${EC_RESET}"
		read -t 60 -n 1 -r && echo

		if [[ ! $REPLY =~ ^[Yy]$ ]]; then
			echo -e "${EC_YELLOW}Proceeding was rejected by user!${EC_RESET}"
			exit 0
		fi
	fi
}

# --------- Dependencies Install Functions ---------

# Install homebrew package manager for MacOS
function install_homebrew () {
	echo -e "${EC_PURPLE}Installing Homebrew.${EC_RESET}"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	export PATH=/opt/homebrew/bin:$PATH
}

# Install dependency by name via 'apt'
function install_core_dependency_debian () {
	echo -e "${EC_PURPLE}Installing ${1} via apt.${RESET}"
	sudo apt install $1
}

function install_core_dependency_macos () {
	echo -e "${EC_PURPLE}Installing ${1} via brew.${RESET}"
	brew install $1
}

# OS type dependent installation of dependency by name
function install_core_dependency () {
	dependency=$1

	if [ -f "/etc/debian_version" ] && hash apt 2> /dev/null; then
		install_core_dependency_debian $dependency

	elif [ "$(uname -s)" = "Darwin" ]; then
		if ! hash brew 2> /dev/null; then install_homebrew; fi
		install_core_dependency_macos $dependency

	else
		echo -e "${EC_YELLOW}Unsupported OS type. Exiting!${EC_RESET}"
		exit 1
	fi
}

# For each core dependency check if not present and install
function install_all_core_dependencies () {
	for dependency in ${CORE_DEPENDENCIES[@]}; do
		if ! hash "${dependency}" 2> /dev/null; then
			install_core_dependency $dependency
		else
			echo -e "${EC_YELLOW}${dependency} is already installed!${EC_RESET}"
		fi
	done
}

# --------- Repo Helper Function ---------

function clone_dotfiles_repository () {
	if [[ ! -d "$REPOSITORY_LOCAL_DIR" ]]; then
		mkdir -p "${REPOSITORY_LOCAL_DIR}" && \
			git clone --recursive ${REPOSITORY_URL} ${REPOSITORY_LOCAL_DIR}
	fi
}

function execute_repository_setup_script () {
	cd "${REPOSITORY_LOCAL_DIR}" && \
		chmod +x ./setup.sh && \
		./setup.sh --no-clear
	}

# --------- Run the Script ---------

print_usage
if [[ $* == *"--help"* ]]; then exit; fi

confirm_proceeding
install_all_core_dependencies

clone_dotfiles_repository
execute_repository_setup_script

echo -e -n "\n${EC_PURPLE}All done, exiting!${EC_RESET}\n"
exit 0

