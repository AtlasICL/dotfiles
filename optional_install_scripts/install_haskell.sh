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
else
  if ! command -v apt-get >/dev/null 2>&1; then
    error "This script supports macOS (Homebrew) and Debian/Ubuntu (apt) systems."
    exit 1
  fi

  if ! sudo -v 2>/dev/null; then
    error "This script requires sudo privileges."
    exit 1
  fi
fi

info "Installing Haskell toolchain..."
# Install the build dependencies that ghcup needs (Linux only; macOS provides
# these via the Xcode Command Line Tools that Homebrew already requires).
if [ "$OS" != "Darwin" ]; then
  sudo apt-get install -y libffi-dev libffi8 libgmp-dev libgmp10 libncurses-dev pkg-config > /dev/null
fi
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# ghcup installs to ~/.ghcup/bin, which is added to PATH via its env file.
if ! command -v ghc >/dev/null 2>&1 && [ ! -x "${HOME}/.ghcup/bin/ghc" ]; then
  warn "ghc not found on PATH yet. Restart your shell (or source ~/.ghcup/env) to use it."
fi

success "Done! It's a good idea to restart your shell."
