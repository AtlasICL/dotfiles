#!/bin/bash

DOTFILES_REPO="git@github.com:AtlasICL/dotfiles"

info()  { printf "\n[INFO] %s\n" "$*"; }

if ! command -v apt >/dev/null 2>&1; then
  error "This script is for Debian/Ubuntu (apt-based) systems."
  exit 1
fi

if ! sudo -v 2>/dev/null; then
  error "This script requires sudo privileges."
  exit 1
fi

info "Updating package lists..."
sudo apt update 

info "Upgrading packages..."
sudo apt upgrade -y

info "Installing git..."
sudo apt install -y git 

info "Installing compilers..."
sudo apt install -y build-essential

info "Getting dotfiles..."
git clone "$DOTFILES_REPO" ~

info "Linking dotfiles into home directory..."
cd ~
cp ./dotfiles/.bashrc ~
cp ./dotfiles/.bash_aliases ~
cp ./dotfiles/.nanorc ~
cp ./dotfiles/.gitconfig ~

source .bashrc

info "Done."
