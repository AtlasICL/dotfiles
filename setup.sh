#!/usr/bin/env bash

set -euo pipefail

# Set up colors for printing.
INFO_COLOR="\033[92m"     # green
SUCCESS_COLOR="\033[35m"  # purple
ERROR_COLOR="\033[31m"    # red
RESET="\033[0m"

# Define console log functions.
info()  { printf "\n${INFO_COLOR}[INFO] %s${RESET}\n" "$*"; }
success() { printf "\n${SUCCESS_COLOR}[OK  ] %s${RESET}\n" "$*"; }
warn() { printf "\n${ERROR_COLOR}[ERR ] %s${RESET}\n" "$*"; }
error() { printf "\n${ERROR_COLOR}[ERR ] %s${RESET}\n" "$*"; }

if ! command -v apt-get >/dev/null 2>&1; then
  error "This script is for Debian/Ubuntu (apt-based) systems."
  exit 1
fi

if ! sudo -v 2>/dev/null; then
  error "This script requires sudo privileges."
  exit 1
fi

# DOTFILES_REPO="https://github.com/AtlasICL/dotfiles"

# if [ ! -d ~/dotfiles/.git ]; then
#   info "Cloning dotfiles..."
#   git clone "$DOTFILES_REPO" ~/dotfiles
# else
#   info "dotfiles directory already exists at: ~/dotfiles. Pulling updates from GitHub..."
#   git -C "~/dotfiles" pull --ff-only || warn "fast-forwards failed: skipping auto-pull."
# fi

info "Updating packages..."
sudo apt-get update > /dev/null 
sudo apt-get upgrade -y > /dev/null

info "Installing git..."
sudo apt-get install -y git > /dev/null 

info "Installing compilers..."
sudo apt-get install -y build-essential > /dev/null

info "Installing dev tools..."
sudo apt-get install -y neovim > /dev/null
sudo apt-get install -y fd-find > /dev/null
sudo apt-get install -y ripgrep > /dev/null
sudo apt-get install -y fzf > /dev/null

info "Linking dotfiles into home directory..."
cp ~/dotfiles/.bashrc ~
cp ~/dotfiles/.bash_aliases ~
cp ~/dotfiles/.nanorc ~
cp ~/dotfiles/.gitconfig ~

info "Linking neovim config files..."
mkdir -p ~/.config  # Create .config directory if necessary
cp -r ~/dotfiles/nvim ~/.config/nvim

success "Done. You should restart your shell."
