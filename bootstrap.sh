#!/usr/bin/env bash

set -euo pipefail

DOTFILES_REPO="https://github.com/AtlasICL/dotfiles"

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

if [ ! -d ~/dotfiles/.git ]; then
  info "Cloning dotfiles..."
  git clone "$DOTFILES_REPO" ~/dotfiles
else
  info "dotfiles directory already exists at: ~/dotfiles. Pulling updates from GitHub..."
  git -C "~/dotfiles" pull --ff-only || warn "fast-forwards failed: skipping auto-pull."
fi

chmod +x ~/dotfiles/setup.sh
~/dotfiles/setup.sh
