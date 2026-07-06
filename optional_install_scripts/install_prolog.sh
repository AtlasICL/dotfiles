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

OS="$(uname -s)"

if [ "$OS" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    error "Homebrew is required on macOS. Install it from https://brew.sh and re-run."
    exit 1
  fi
  # Keep brew quiet (chatter goes to stderr); real errors still surface.
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_ENV_HINTS=1
  info "Installing SWI-Prolog via Homebrew..."
  brew install --quiet swi-prolog > /dev/null
else
  if ! command -v apt-get >/dev/null 2>&1; then
    error "This script supports macOS (Homebrew) and Debian/Ubuntu (apt) systems."
    exit 1
  fi

  if ! sudo -v 2>/dev/null; then
    error "This script requires sudo privileges."
    exit 1
  fi

  sudo apt-get install -y software-properties-common > /dev/null
  sudo apt-add-repository -y ppa:swi-prolog/stable > /dev/null
  sudo apt-get update > /dev/null
  sudo apt-get install -y swi-prolog > /dev/null
fi

if ! command -v swipl >/dev/null 2>&1; then
  error "Something went wrong!"
  error "SWI-Prolog (swipl) not found on PATH after installation."
  exit 1
fi

success "Done! It's a good idea to restart your shell."
