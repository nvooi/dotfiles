#!/usr/bin/env bash

# =============================================================================
#  Dotfiles Setup Script
# =============================================================================
#
#  Repository:   https://github.com/nvooi/dotfiles
#  Description:  Automates installation and linking of dotfiles and related
#                developer environment configuration.
#
#  Features:
#    - Ensures required dependencies (git, zsh, vim, brew)
#    - Clones or updates dotfiles repo
#    - Creates symlinks for config files
#    - Optionally installs Homebrew, Ruby gems, CodeLLDB
#    - Optionally applies system preferences
#
#  Usage:
#    ./setup.sh [--auto-confirm] [--no-clear] [--help]
#
#  Options:
#    --auto-confirm     Skip interactive confirmation prompts
#    --no-clear         Do not clear the terminal before running
#    --help             Show usage and exit
#
#  Exit Codes:
#    0 - success
#    1 - error or user abort
# =============================================================================

# --------- Repository Settings --------------

REPOSITORY_LOCAL_DIR="${REPOSITORY_LOCAL_DIR:-$HOME/Projects/dotfiles}"
REPOSITORY_URL="${REPOSITORY_URL:-https://github.com/nvooi/dotfiles}"

# --------- System Settings ------------------

SOURCE_DIR=$(dirname ${0})
CURRENT_DIR=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)
SYSTEM_TYPE=$(uname -s)
START_TIME=$(date +%s)

# --------- Escape Codes ---------------------

EC_RED='\033[1;31m'
EC_GREEN='\033[1;32m'
EC_PURPLE='\033[0;35m'
EC_YELLOW='\033[0;93m'
EC_CYAN='\033[0;96m'
EC_LIGHT='\x1b[2m'
EC_RESET='\033[0m'

# --------- Script Usage ---------------------

## @function print_usage
## @description Prints a rich, expressive usage guide with colorized sections and examples.
function print_usage() {
	echo -e "\n${EC_PURPLE}Dotfiles Installation Script${EC_RESET}\n"
    echo -e "${EC_CYAN}Description:${EC_RESET}"
    echo -e "  Automates configuration of your development environment by linking"
    echo -e "  dotfiles, installing required packages, and applying macOS preferences.\n"

    echo -e "${EC_CYAN}Behavior:${EC_RESET}"
    echo -e "  Ensures all required tools (git, zsh, vim, brew) are installed."
    echo -e "  Pulls the latest version of your dotfiles repository."
    echo -e "  Creates symlinks for zsh, git, nvim, and other configs."
    echo -e "  Optionally installs system and Ruby gem packages."
    echo -e "  Optionally applies macOS system preferences."
    echo -e "  Reloads the environment upon completion.\n"

    echo -e "${EC_CYAN}Environment Variables:${EC_RESET}"
    echo -e "  ${EC_YELLOW}REPOSITORY_LOCAL_DIR${EC_RESET}   Override local path to dotfiles repo."
    echo -e "  ${EC_YELLOW}REPOSITORY_URL${EC_RESET}         Override remote Git URL for dotfiles.\n"
}

# --------- Banner Utilities -----------------

## @function banner_length
## @description Calculates banner width based on text length and optional padding.
## @param $1 Text string
## @param $2 Optional padding length (default 0)
## @output Echoes integer length
function banner_length() {
    local text=$1
    local padding_length="${3:-0}"
    echo $(expr ${#text} + 4 + $padding_length)
}

## @function print_banner
## @description Prints a colored banner with a message surrounded by borders.
## @param $1 Text string
## @param $2 Optional color (default cyan)
function print_banner() {
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

# --------- Termination Handler --------------

## @function terminate
## @description Prints failure banner and exits the script with code 1.
function terminate() {
    print_banner "Setup failed. Terminating!" $EC_RED
    exit 1
}

# --------- Confirmation Prompts -------------

## @function confirm_proceeding
## @description Asks user for confirmation to proceed unless --auto-confirm is passed.
## @param $@ Script arguments (checked for --auto-confirm)
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

# --------- Environment Preparation ----------

## @function prepare_setup
## @description Ensures all required tools exist and sets default XDG environment paths.
function prepare_setup() {
    ensure_command_available "git" true
    ensure_command_available "vim" false
    ensure_command_available "zsh" false

    if [ "${SYSTEM_TYPE}" = "Darwin" ]; then
        export PATH="/opt/homebrew/bin:$PATH"
        ensure_command_available "brew" true
    fi

    if [ -z ${XDG_CONFIG_HOME+x} ]; then
        echo -e "${EC_YELLOW}[WARNING]: XDG_CONFIG_HOME not set. Using ~/.config${EC_RESET}"
        export XDG_CONFIG_HOME="${HOME}/.config"
    fi
    if [ -z ${XDG_DATA_HOME+x} ]; then
        echo -e "${EC_YELLOW}[WARNING]: XDG_DATA_HOME not set. Using ~/.local/share${EC_RESET}"
        export XDG_DATA_HOME="${HOME}/.local/share"
    fi
}

# --------- Dependency Helpers ---------------

## @function is_command_available
## @description Checks if a command exists in PATH.
## @param $1 Command name
## @return 0 if available, non-zero otherwise
function is_command_available() {
    hash "$1" 2>/dev/null
}

## @function ensure_command_available
## @description Verifies command availability, optionally terminates on failure.
## @param $1 Command name
## @param $2 true if required, false if optional
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

# --------- Configuration Installation -------

## @function make_soft_link
## @description Creates a symbolic link from source to target if source exists.
## @param $1 Target file path
## @param $2 Source relative path (from repository root)
function make_soft_link() {
    local target="$1"
    local source="$2"
    echo -e "${EC_GREEN}[INFO]: Linking $target -> $source${EC_RESET}"
    mkdir -p "$(dirname $target)"
    if [[ -f "$PWD/$source" || -d "$PWD/$source" ]]; then
        ln -sf "$PWD/$source" "$target"
    fi
}

## @function install_configs
## @description Pulls the latest dotfiles repo and sets up symbolic links.
function install_configs() {
    if [[ ! -d "${REPOSITORY_LOCAL_DIR}" ]]; then
        echo -e "${EC_RED}[ERROR]: Dotfiles repo ${REPOSITORY_LOCAL_DIR} not found.${EC_RESET}"
        terminate
    else
        echo -e "${EC_GREEN}[INFO]: Pulling latest changes from ${REPOSITORY_URL}.${EC_RESET}"
        cd "${REPOSITORY_LOCAL_DIR}" && git pull origin main
    fi

    echo -e "${EC_GREEN}[INFO]: Cleaning old symlinks.${EC_RESET}"
    rm -rf "$HOME/.zshenv" "$XDG_CONFIG_HOME"

    echo -e "${EC_GREEN}[INFO]: Creating new symlinks.${EC_RESET}"
    make_soft_link "$HOME/.zshenv" "config/zsh/.zshenv"
    make_soft_link "$HOME/.gitconfig" "config/git/.gitconfig"
    make_soft_link "$XDG_CONFIG_HOME/zsh" "config/zsh"
    make_soft_link "$XDG_CONFIG_HOME/nvim" "config/nvim"
    make_soft_link "$XDG_CONFIG_HOME/kitty" "config/kitty"
    make_soft_link "$XDG_CONFIG_HOME/aerospace" "config/aerospace"
    make_soft_link "$XDG_CONFIG_HOME/.gitignore_global" "config/git/.gitignore_global"
    echo
}

# --------- System Preferences Setup ---------

## @function install_macos_system_preferences
## @description Executes macOS-specific preferences setup script if found.
function install_macos_system_preferences() {
    local f="${REPOSITORY_LOCAL_DIR}/script/macos/install.sh"
    if [ -f "${f}" ]; then
        echo -e "${EC_GREEN}[INFO]: Setting system preferences.${EC_RESET}"
        chmod +x "${f}" && ( $f )
    else
        echo -e "${EC_YELLOW}[WARNING]: System preferences script not found!${EC_RESET}"
    fi
}

## @function install_system_preferences
## @description Prompts user and installs system preferences for macOS.
function install_system_preferences() {
    echo -en "${EC_CYAN}Would you like to set system preferences? (y/N)${EC_RESET}\n"
    read -t 60 -n 1 -r ans && echo -e "\n"

    if [[ ! $ans =~ ^[Yy]$ ]]; then
        echo -e "${EC_YELLOW}[WARNING]: Skipping system preferences setup.${EC_RESET}\n"
        return
    fi

    if [ "${SYSTEM_TYPE}" = "Darwin" ]; then
        install_macos_system_preferences
    else
        echo -e "${EC_RED}[ERROR]: Unsupported OS type!${EC_RESET}"
        terminate
    fi
}

# --------- Package Installation -------------

## @function install_macos_packages
## @description Installs or updates Homebrew packages using Brewfile.
function install_macos_packages() {
    if ! is_command_available "brew"; then
        echo -e "${EC_YELLOW}[WARNING]: Homebrew not installed!${EC_RESET}"
        return
    fi

    local f="${REPOSITORY_LOCAL_DIR}/script/Brewfile"
    if [ -f "${f}" ]; then
        echo -e "${EC_GREEN}[INFO]: Updating Homebrew and installing packages.${EC_RESET}"
        brew update && brew upgrade && brew bundle --file "${f}"
        brew cleanup
        killall Finder
    else
        echo -e "${EC_YELLOW}[WARNING]: Brewfile not found!${EC_RESET}"
    fi
}

## @function install_gem_packages
## @description Installs Ruby gems from gemfile.sh if gem is available.
function install_gem_packages() {
    if ! is_command_available "gem"; then
        echo -e "${EC_YELLOW}[WARNING]: gem not installed!${EC_RESET}"
        return
    fi

    local f="${REPOSITORY_LOCAL_DIR}/script/gemfile.sh"
    if [ -f "${f}" ]; then
        echo -e "${EC_GREEN}[INFO]: Updating gem packages.${EC_RESET}"
        chmod +x "${f}" && . $f
    else
        echo -e "${EC_YELLOW}[WARNING]: gemfile.sh not found!${EC_RESET}"
    fi
}

## @function install_codelldb
## @description Installs CodeLLDB VSCode extension into XDG data dir if user confirms.
function install_codelldb() {
    local d="$XDG_DATA_HOME/codelldb"
    local u=""

    if [ "${SYSTEM_TYPE}" = "Darwin" ]; then
        u="https://github.com/vadimcn/codelldb/releases/download/v1.11.7/codelldb-darwin-arm64.vsix"
    fi

    if [[ -z "${u}" || -d "${d}" ]]; then
        return
    fi

    echo -en "${EC_CYAN}Would you like to install codelldb? (y/N)${EC_RESET}\n"
    read -t 60 -n 1 -r ans && echo -e "\n"

    if [[ ! $ans =~ ^[Yy]$ ]]; then
        echo -e "${EC_YELLOW}[WARNING]: Skipping codelldb installation.${EC_RESET}\n"
        return
    fi

    curl --create-dirs -O -L --output-dir /tmp/codelldb "${u}" && \
        unzip /tmp/codelldb/codelldb-darwin-arm64.vsix -d "${d}"
    rm -rf /tmp/codelldb
}

## @function install_packages
## @description Installs system packages (brew, gem, etc.) based on OS and user confirmation.
function install_packages() {
    echo -en "${EC_CYAN}Would you like to install system packages? (y/N)${EC_RESET}\n"
    read -t 60 -n 1 -r ans && echo -e "\n"

    if [[ ! $ans =~ ^[Yy]$ ]]; then
        echo -e "${EC_YELLOW}[WARNING]: Skipping system packages installation.${EC_RESET}\n"
        return
    fi

    if [ "${SYSTEM_TYPE}" = "Darwin" ]; then
        install_macos_packages && echo
        install_gem_packages && echo
    else
        echo -e "${EC_RED}[ERROR]: Unsupported OS type!${EC_RESET}"
        terminate
    fi

    install_codelldb
    echo
}

# --------- Finalization ---------------------

## @function finalize_setup
## @description Reloads ZSH environment and waits for user keypress before exiting.
function finalize_setup() {
    source "${HOME}/.zshenv"
    echo -e "${EC_GREEN}[FINISHED]: Press any key to exit.${EC_RESET}"
    read -t 60 -n 1 -s
    exit 0
}

# --------- Run the Script -------------------

if [[ ! $* == *"--no-clear"* ]] && [[ ! $* == *"--help"* ]]; then
    clear
fi

print_usage
if [[ $* == *"--help"* ]]; then exit 0; fi

confirm_proceeding "$@"
prepare_setup
install_configs
install_system_preferences
install_packages
finalize_setup

