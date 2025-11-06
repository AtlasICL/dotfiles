#!/bin/bash

#DOTFILES_REPO="git@github.com:AtlasICL/dotfiles"

# Set up colors for printing.
INFO_COLOR="\033[94m"     # blue
SUCCESS_COLOR="\033[35m"  # purple
ERROR_COLOR="\033[31m"    # red
RESET="\033[0m"

# Define console log functions.
info()  { printf "\n${INFO_COLOR}[INFO] %s${RESET}\n" "$*"; }
success() { printf "\n${SUCCESS_COLOR}[OK  ] %s${RESET}\n" "$*"; }
error() { printf "\n${ERROR_COLOR}[ERR ] %s${RESET}\n" "$*"; }

if ! command -v apt >/dev/null 2>&1; then
  error "This script is for Debian/Ubuntu (apt-based) systems."
  exit 1
fi

if ! sudo -v 2>/dev/null; then
  error "This script requires sudo privileges."
  exit 1
fi

info "Updating package lists..."
sudo apt-get update > /dev/null 

info "Upgrading packages..."
sudo apt-get upgrade -y > /dev/null

info "Installing git..."
sudo apt-get install -y git > /dev/null 

info "Installing compilers..."
sudo apt-get install -y build-essential > /dev/null

#info "Getting dotfiles..."
#git clone "$DOTFILES_REPO" ~

info "Linking dotfiles into home directory..."
cp ~/dotfiles/.bashrc ~
cp ~/dotfiles/.bash_aliases ~
cp ~/dotfiles/.nanorc ~
cp ~/dotfiles/.gitconfig ~

source .bashrc

success "Done."
