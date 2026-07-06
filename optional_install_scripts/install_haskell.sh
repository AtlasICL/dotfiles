#!/usr/bin/env bash

set -euo pipefail

# Set up colors for printing.
INFO_COLOR="\033[92m"       # green
SUCCESS_COLOR="\033[35m"    # purple
ERROR_COLOR="\033[31m"      # red
BAKINFO_COLOR="\033[94m"    # blue
PROG_COLOR="\033[38;5;208m" # orange
BG_NAVY="\033[48;5;19m"     # dark blue (for highlighting)
RESET="\033[0m"

# Define console log functions.
info()  { printf "\n${INFO_COLOR}[INFO] %s${RESET}\n" "$*"; }
bakinfo() { printf "${BAKINFO_COLOR}[INFO] %s${RESET}\n" "$*"; }
success() { printf "\n${SUCCESS_COLOR}[OK  ] %s${RESET}\n" "$*"; }
warn() { printf "\n${ERROR_COLOR}[WARN] %s${RESET}\n" "$*"; }
error() { printf "\n${ERROR_COLOR}[ERR ] %s${RESET}\n" "$*"; }

if ! command -v apt-get >/dev/null 2>&1; then
  error "This script is for Debian/Ubuntu (apt-based) systems."
  exit 1
fi

if ! sudo -v 2>/dev/null; then
  error "This script requires sudo privileges."
  exit 1
fi

info "Installing Haskell toolchain..."
sudo apt-get install libffi-dev libffi8 libgmp-dev libgmp10 libncurses-dev pkg-config > /dev/null
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

if ! command -v swipl >/dev/null 2>&1; then
  error "Something went wrong!"
  error "Haskell compiler (ghc) not found on PATH after installation."
  exit 1
fi

success "Done! It's a good idea to restart your shell."
