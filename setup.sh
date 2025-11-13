#!/usr/bin/env bash

set -euo pipefail

# Set up colors for printing.
INFO_COLOR="\033[92m"       # green
SUCCESS_COLOR="\033[35m"    # purple
ERROR_COLOR="\033[31m"      # red
BAKINFO_COLOR="\033[94m"    # blue
PROG_COLOR="\033[38;5;208m" # orange
RESET="\033[0m"

# Define console log functions.
info()  { clear_progress; printf "\n${INFO_COLOR}[INFO] %s${RESET}\n" "$*"; draw_progress; }
bakinfo() { clear_progress; printf "${BAKINFO_COLOR}[INFO] %s${RESET}\n" "$*"; draw_progress; }
success() { clear_progress; printf "\n${SUCCESS_COLOR}[OK  ] %s${RESET}\n" "$*"; }
warn() { clear_progress; printf "\n${ERROR_COLOR}[WARN] %s${RESET}\n" "$*"; draw_progress; }
error() { clear_progress; printf "\n${ERROR_COLOR}[ERR ] %s${RESET}\n" "$*"; }

# ------------ PROGRESS BAR HELPERS ------------
# Progress bar variables
TOTAL_STEPS=24
CURRENT_STEP=0
PROGRESS_DRAWN=0

# Save cursor position and draw progress bar
draw_progress() {
  local percent=$((CURRENT_STEP * 100 / TOTAL_STEPS))
  local filled=$((percent / 2))
  local empty=$((50 - filled))
  
  # Save cursor, move to bottom, draw progress, restore cursor
  tput sc  # Save cursor position
  tput cup $(tput lines) 0  # Move to last line
  printf "${PROG_COLOR}Progress: ["
  printf "%${filled}s" | tr ' ' '#'
  printf "%${empty}s" | tr ' ' '.'
  printf "] %3d%%${RESET}" "$percent"
  tput el  # Clear to end of line
  tput rc  # Restore cursor position
  PROGRESS_DRAWN=1
}

# Clear the progress bar line
clear_progress() {
  if [ "$PROGRESS_DRAWN" -eq 1 ]; then
    tput sc  # Save cursor
    tput cup $(tput lines) 0  # Move to last line
    tput el  # Clear line
    tput rc  # Restore cursor
  fi
}

update_progress() {
  CURRENT_STEP=$((CURRENT_STEP + 1))
  draw_progress
}
# -------- END PROGRESS BAR HELPERS --------


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

info "Starting setup..."
update_progress

info "Checking for SSH key..."
if [ ! -f "${HOME}/.ssh/id_ed25519" ] && [ ! -f "${HOME}/.ssh/id_rsa" ]; then
  bakinfo "No SSH key found. Generating..."
  mkdir -p "${HOME}/.ssh"
  chmod 700 "${HOME}/.ssh"
  ssh-keygen -t ed25519 -f "${HOME}/.ssh/id_ed25519" -N "" -C "$(whoami)@$(hostname)" > /dev/null 2>&1
else
  bakinfo "SSH key already exists, skipping."
fi
update_progress

info "Setting hush login..."
touch "${HOME}/.hushlogin"
update_progress

info "Updating packages..."
sudo apt-get update > /dev/null 
update_progress

sudo apt-get upgrade -y > /dev/null
update_progress

# Ensure wget is installed (needed for fastfetch install)
info "Checking wget installed..."
if ! command -v wget >/dev/null 2>&1; then
  bakinfo "wget not found, installing wget..."
  sudo apt-get install -y wget > /dev/null
else 
  bakinfo "wget already installed, skipping..."
fi
update_progress

info "Installing git..."
sudo apt-get install -y git > /dev/null 
update_progress

info "Installing C/C++ compilers..."
sudo apt-get install -y build-essential > /dev/null
update_progress

info "Installing Python and pip..."
sudo apt-get install -y python3 > /dev/null
sudo apt-get install -y python3-pip > /dev/null
update_progress

info "Installing htop..."
sudo apt-get install -y libncursesw5-dev autotools-dev autoconf automake > /dev/null
sudo apt-get install -y htop > /dev/null
update_progress

info "Installing tmux..."
sudo apt-get install -y tmux > /dev/null
update_progress

info "Installing fd..."
sudo apt-get install -y fd-find > /dev/null
update_progress

info "Installing ripgrep..."
sudo apt-get install -y ripgrep > /dev/null
update_progress

info "Installing fzf..."
sudo apt-get install -y fzf > /dev/null
update_progress

info "Installing tree..."
sudo apt-get install -y tree > /dev/null
update_progress

info "Installing neovim..."
sudo apt-get install -y neovim > /dev/null
update_progress

info "Installing fastfetch..."
if ! command -v fastfetch >/dev/null 2>&1; then
  bakinfo "Checking compatibility..."
  ARCH="$(dpkg --print-architecture)"
  if [ "$ARCH" = "amd64" ]; then
    bakinfo "amd64 ISA detected, installing fastfetch..."
    wget -O /tmp/fastfetch.deb https://github.com/fastfetch-cli/fastfetch/releases/download/2.55.0/fastfetch-linux-amd64.deb
    sudo apt-get install -y /tmp/fastfetch.deb > /dev/null
    rm /tmp/fastfetch.deb # Explicitly delete after installation
  else 
    warn "System is not amd64 - skipping fastfetch installation"
  fi
else
  bakinfo "fastfetch already installed, skipping..."
fi
update_progress

# Neovim expects fd, so we will link fd to fd-find.
mkdir -p ~/.local/bin # Create the directory if it doesn't exist.
if command -v fdfind >/dev/null 2>&1; then
  ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
else
  warn "fdfind not found, skipping fd symlink"
fi
update_progress

info "Backing up current configs..."
backup "${HOME}/.bashrc"
backup "${HOME}/.bash_aliases"
backup "${HOME}/.nanorc"
backup "${HOME}/.gitconfig"
update_progress

info "Linking dotfiles into home directory..."
cp "${HOME}/dotfiles/.bashrc" "${HOME}"
update_progress

cp "${HOME}/dotfiles/.bash_aliases" "${HOME}"
update_progress

cp "${HOME}/dotfiles/.nanorc" "${HOME}"
update_progress

cp "${HOME}/dotfiles/.gitconfig" "${HOME}"
update_progress

info "Backing up neovim config..."
backup "${HOME}/.config/nvim"
update_progress

info "Linking neovim config files..."
mkdir -p "${HOME}/.config"  # Create .config directory if necessary.
cp -r "${HOME}/dotfiles/nvim" "${HOME}/.config/nvim"
update_progress

clear_progress
success "Done. You should restart your shell. o7"