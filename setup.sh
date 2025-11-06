#!/bin/bash

DOTFILES_REPO="git@github.com:AtlasICL/dotfiles"

info()  { printf "\n[INFO] %s\n" "$*"; }

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
