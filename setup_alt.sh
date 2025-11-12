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
bakinfo() { printf "\n${BAKINFO_COLOR}[INFO] %s${RESET}\n" "$*"; }
success() { printf "\n${SUCCESS_COLOR}[OK  ] %s${RESET}\n" "$*"; }
warn() { printf "\n${ERROR_COLOR}[WARN] %s${RESET}\n" "$*"; }
error() { printf "\n${ERROR_COLOR}[ERR ] %s${RESET}\n" "$*"; }

# ---- progress bar helpers ----
TOTAL_STEPS=9        # set this to the number of steps you plan to run
CURRENT_STEP=0

_is_tty() { [ -t 1 ]; }

_draw_bar() {
  local width fill empty percent
  percent=$(( CURRENT_STEP * 100 / TOTAL_STEPS ))
  width=$(( $(_is_tty && tput cols || echo 80) - 20 ))
  (( width < 10 )) && width=10
  fill=$(( percent * width / 100 ))
  empty=$(( width - fill ))
  printf "\r[%-*s] %3d%%  %s" "$width" "$(printf '%*s' "$fill" '' | tr ' ' '#')" "$percent" "$1"
}

step() {
  local msg="$1"; shift || true
  (( CURRENT_STEP++ ))
  _draw_bar "$msg"
}

end_progress() {
  _draw_bar "Done"
  printf "\n"
}
# ---- end helpers ----

# Function to create time-stamped backups of the files this script might overwrite.
backup() {
  local target="$1"
  if [ -e "$target" ]; then
    local ts="$(date +%Y%m%d-%H%M%S)"
    local backup_path="${target}.bak.${ts}"
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

step "Updating packages..."
sudo apt-get update > /dev/null 
sudo apt-get upgrade -y > /dev/null

step "Installing git..."
sudo apt-get install -y git > /dev/null 

step "Installing compilers..."
sudo apt-get install -y build-essential > /dev/null

step "Installing dev tools..."
sudo apt-get install -y neovim > /dev/null
sudo apt-get install -y fd-find > /dev/null
sudo apt-get install -y ripgrep > /dev/null
sudo apt-get install -y fzf > /dev/null

step "Backing up current configs..."
backup "${HOME}/.bashrc"
backup "${HOME}/.bash_aliases"
backup "${HOME}/.nanorc"
backup "${HOME}/.gitconfig"

step "Linking dotfiles into home directory..."
cp "${HOME}/dotfiles/.bashrc" "${HOME}"
cp "${HOME}/dotfiles/.bash_aliases" "${HOME}"
cp "${HOME}/dotfiles/.nanorc" "${HOME}"
cp "${HOME}/dotfiles/.gitconfig" "${HOME}"

step "Backing up neovim config..."
backup "${HOME}/.config/nvim"

step "Linking neovim config files..."
mkdir -p "${HOME}/.config"  # Create .config directory if necessary
cp -r "${HOME}/dotfiles/nvim" "${HOME}/.config/nvim"

success "Done. You should restart your shell."
