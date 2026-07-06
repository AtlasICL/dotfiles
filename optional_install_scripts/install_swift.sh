#!/usr/bin/env bash

set -euo pipefail

OS="$(uname -s)"

if [ "$OS" = "Darwin" ]; then
  # On macOS, Swift ships with Xcode / the Xcode Command Line Tools.
  if xcrun --find swift >/dev/null 2>&1; then
    echo "Swift is already available (provided by Xcode Command Line Tools)."
  else
    echo "Installing the Xcode Command Line Tools (includes Swift)..."
    xcode-select --install
    echo "Follow the on-screen prompt to finish installing the Command Line Tools."
  fi
else
  curl -O "https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz" && \
  tar zxf "swiftly-$(uname -m).tar.gz" && \
  ./swiftly init --quiet-shell-followup && \
  . "${SWIFTLY_HOME_DIR:-$HOME/.local/share/swiftly}/env.sh" && \
  hash -r
fi