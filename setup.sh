#!/usr/bin/env bash

set -euo pipefail

# Set up colors for printing.
INFO_COLOR="\033[92m"     # green
SUCCESS_COLOR="\033[35m"  # purple
ERROR_COLOR="\033[31m"    # red
BAKINFO_COLOR="\033[94m"  # blue
RESET="\033[0m"

# Define console log functions.
info()  { printf "\n${INFO_COLOR}[INFO] %s${RESET}\n" "$*"; }
bakinfo() { printf "${BAKINFO_COLOR}[INFO] %s${RESET}\n" "$*"; }
success() { printf "\n${SUCCESS_COLOR}[OK  ] %s${RESET}\n" "$*"; }
warn() { printf "\n${ERROR_COLOR}[WARN] %s${RESET}\n" "$*"; }
error() { printf "\n${ERROR_COLOR}[ERR ] %s${RESET}\n" "$*"; }

BACKUP_DIR="${HOME}/atlas-setup-backups"

# Function to create time-stamped backups of the files this script might overwrite.
backup() {
  local target="$1"
  mkdir -p "$BACKUP_DIR"
  if [ -e "$target" ]; then
    local timestamp="$(date +%Y%m%d-%H%M%S)" # for time-stamped backups
    local filename="$(basename "$target")"
    local backup_path="${BACKUP_DIR}/${filename}.bak.${timestamp}"
    bakinfo "Backing up $target -> $backup_path"
    cp -a -- "$target" "$backup_path"
    bakinfo "Backup successful"
  fi
}

if ! command -v apt-get >/dev/null 2>&1; then
  error "This script is for Debian/Ubuntu (apt-based) systems."
  exit 1
fi

if ! sudo -v 2>/dev/null; then
  error "This script requires sudo privileges."
  exit 1
fi

if [ ! -d "${HOME}/dotfiles" ]; then
  error "Missing ${HOME}/dotfiles directory. Clone dotfiles repo."
  exit 1
fi

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

# Neovim expects fd, so we will link fd to fd-find.
mkdir -p ~/.local/bin # Create the directory if it doesn't exist.
if command -v fdfind >/dev/null 2>&1; then
  ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
else
  warn "fdfind not found, skipping fd symlink"
fi

info "Backing up current configs..."
backup "${HOME}/.bashrc"
backup "${HOME}/.bash_aliases"
backup "${HOME}/.nanorc"
backup "${HOME}/.gitconfig"

info "Linking dotfiles into home directory..."
cp "${HOME}/dotfiles/.bashrc" "${HOME}"
cp "${HOME}/dotfiles/.bash_aliases" "${HOME}"
cp "${HOME}/dotfiles/.nanorc" "${HOME}"
cp "${HOME}/dotfiles/.gitconfig" "${HOME}"

info "Backing up neovim config..."
backup "${HOME}/.config/nvim"

info "Linking neovim config files..."
mkdir -p "${HOME}/.config"  # Create .config directory if necessary.
cp -r "${HOME}/dotfiles/nvim" "${HOME}/.config/nvim"

success "Done. You should restart your shell."
