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
info()  { clear_progress; printf "\n${INFO_COLOR}[INFO] %s${RESET}\n" "$*"; draw_progress; }
bakinfo() { clear_progress; printf "${BAKINFO_COLOR}[INFO] %s${RESET}\n" "$*"; draw_progress; }
success() { clear_progress; printf "\n${SUCCESS_COLOR}[OK  ] %s${RESET}\n" "$*"; }
warn() { clear_progress; printf "\n${ERROR_COLOR}[WARN] %s${RESET}\n" "$*"; draw_progress; }
error() { clear_progress; printf "\n${ERROR_COLOR}[ERR ] %s${RESET}\n" "$*"; }

# ------------ PROGRESS BAR HELPERS ------------
# Progress bar variables
TOTAL_STEPS=28
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
  printf "${BG_NAVY}${PROG_COLOR}Progress:${RESET}${PROG_COLOR} ["
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


BACKUP_DIR="${HOME}/.atlas-setup-backups"

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
  fi
}

# ------------ OS DETECTION & HELPERS ------------
OS="$(uname -s)"

# pkg_install <apt-name>: install a package with the platform package manager,
# translating names that differ between apt (Debian/Ubuntu) and brew (macOS).
pkg_install() {
  local name="$1"
  if [ "$OS" = "Darwin" ]; then
    local brew_name="$name"
    case "$name" in
      fd-find)         brew_name="fd" ;;
      default-jdk)     brew_name="openjdk" ;;
      python3-pip)     return 0 ;; # pip ships with Homebrew's python3
      build-essential) return 0 ;; # provided by Xcode Command Line Tools
    esac
    brew install "$brew_name" >/dev/null
  else
    sudo apt-get install -y "$name" >/dev/null
  fi
}

# append_block <file> <marker>: append stdin to <file> only if <marker> is
# not already present. Creates the file if it does not exist.
append_block() {
  local file="$1" marker="$2"
  [ -f "$file" ] || touch "$file"
  if ! grep -qF "$marker" "$file"; then
    cat >> "$file"
  fi
}
# ---------- END OS DETECTION & HELPERS ----------

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

info "Ensuring allowed signers file exists"
if [ ! -f "${HOME}/.ssh/allowed_signers" ]; then
  bakinfo "No allowed signers file found. Generating empty file..."
  touch "${HOME}/.ssh/allowed_signers"
else
  bakinfo "Allowed signers file already exists, skipping."
fi
update_progress 

info "Setting hush login..."
touch "${HOME}/.hushlogin"
update_progress

info "Updating packages..."
if [ "$OS" = "Darwin" ]; then
  brew update > /dev/null
  update_progress
  brew upgrade > /dev/null
  update_progress
else
  sudo apt-get update > /dev/null
  update_progress
  sudo apt-get upgrade -y > /dev/null
  update_progress
fi

# wget/tar are only needed for the Linux fastfetch .deb install below.
if [ "$OS" != "Darwin" ]; then
  info "Checking wget installed..."
  if ! command -v wget >/dev/null 2>&1; then
    bakinfo "wget not found, installing wget..."
    sudo apt-get install -y wget > /dev/null
  else
    bakinfo "wget already installed, skipping."
  fi
  update_progress

  info "Checking tar installed..."
  if ! command -v tar >/dev/null 2>&1; then
    bakinfo "tar not found, installing tar..."
    sudo apt-get install -y tar > /dev/null
  else
    bakinfo "tar already installed, skipping."
  fi
  update_progress
fi

info "Installing git..."
pkg_install git
update_progress

info "Installing C/C++ compilers..."
pkg_install build-essential
update_progress

info "Installing Python and pip..."
pkg_install python3
pkg_install python3-pip
update_progress

info "Installing java and maven..."
pkg_install default-jdk
pkg_install maven
update_progress

info "Installing htop..."
if [ "$OS" != "Darwin" ]; then
  sudo apt-get install -y libncursesw5-dev autotools-dev autoconf automake > /dev/null
fi
pkg_install htop
update_progress

info "Installing tmux..."
pkg_install tmux
update_progress

info "Installing fd..."
pkg_install fd-find
update_progress

info "Installing ripgrep..."
pkg_install ripgrep
update_progress

info "Installing fzf..."
pkg_install fzf
update_progress

info "Installing tree..."
pkg_install tree
update_progress

info "Installing neovim..."
pkg_install neovim
update_progress

info "Installing bat..."
pkg_install bat
update_progress

info "Installing fastfetch..."
if [ "$OS" = "Darwin" ]; then
  bakinfo "Skipping fastfetch on macOS."
elif ! command -v fastfetch >/dev/null 2>&1; then
  bakinfo "Checking compatibility..."
  ARCH="$(dpkg --print-architecture)"
  if [ "$ARCH" = "amd64" ]; then
    bakinfo "amd64 ISA detected, installing fastfetch..."
    wget -O /tmp/fastfetch.deb https://github.com/fastfetch-cli/fastfetch/releases/download/2.55.0/fastfetch-linux-amd64.deb > /dev/null 2>&1
    sudo apt-get install -y /tmp/fastfetch.deb > /dev/null
    rm /tmp/fastfetch.deb # Explicitly delete after installation
  else
    warn "System is not amd64 - skipping fastfetch installation"
  fi
else
  bakinfo "fastfetch already installed, skipping."
fi
update_progress

# Neovim expects fd. On Debian the binary is named fdfind, so symlink it to fd.
# On macOS the Homebrew binary is already named fd, so nothing to do.
if [ "$OS" != "Darwin" ]; then
  mkdir -p "${HOME}/.local/bin" # Create the directory if it doesn't exist.
  if command -v fdfind >/dev/null 2>&1; then
    ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
  else
    warn "fdfind not found, skipping fd symlink."
  fi
fi
update_progress

info "Backing up current configs..."
backup "${HOME}/.bashrc"
backup "${HOME}/.shell_common.sh"
backup "${HOME}/.bash_aliases"
backup "${HOME}/.nanorc"
backup "${HOME}/.gitconfig"
backup "${HOME}/.config/fastfetch"
backup "${HOME}/.inputrc"
backup "${HOME}/.tmux.conf"
if [ "$OS" = "Darwin" ]; then
  backup "${HOME}/.zshrc"
  backup "${HOME}/.bash_profile"
fi
update_progress

info "Linking dotfiles into home directory..."
cp "${HOME}/dotfiles/.bashrc" "${HOME}"
cp "${HOME}/dotfiles/.shell_common.sh" "${HOME}"
cp "${HOME}/dotfiles/.bash_aliases" "${HOME}"
cp "${HOME}/dotfiles/.git_commands_custom.sh" "${HOME}"
cp "${HOME}/dotfiles/.tmux_commands_custom.sh" "${HOME}"
cp "${HOME}/dotfiles/.nanorc" "${HOME}"
cp "${HOME}/dotfiles/.gitconfig" "${HOME}"
cp "${HOME}/dotfiles/.inputrc" "${HOME}"
cp "${HOME}/dotfiles/.tmux.conf" "${HOME}"
update_progress

# The committed .bashrc sources ~/.shell_common.sh (which loads aliases and the
# custom git/tmux command files). On macOS we also wire up zsh and bash login
# shells so both shells share the same configuration.
RC_FILES=("${HOME}/.bashrc")
if [ "$OS" = "Darwin" ]; then
  RC_FILES+=("${HOME}/.zshrc")

  info "Configuring zsh (~/.zshrc)..."
  append_block "${HOME}/.zshrc" "shared shell config (added by setup script)" <<'EOF'

# --- shared shell config (added by setup script) ---
if [[ -f ~/.shell_common.sh ]]; then
    . ~/.shell_common.sh
fi
# --- end shared shell config ---
EOF
  update_progress

  info "Ensuring ~/.bash_profile sources ~/.bashrc..."
  append_block "${HOME}/.bash_profile" "source .bashrc (added by setup script)" <<'EOF'

# --- source .bashrc (added by setup script) ---
if [[ -f ~/.bashrc ]]; then
    . ~/.bashrc
fi
# --- end source .bashrc ---
EOF
  update_progress
fi

info "Configuring JAVA_HOME..."
JAVA_HOME_VALUE=""
if [ "$OS" = "Darwin" ]; then
  if /usr/libexec/java_home >/dev/null 2>&1; then
    JAVA_HOME_VALUE="$(/usr/libexec/java_home)"
  else
    # Homebrew's openjdk is keg-only and not registered with java_home.
    brew_jdk="$(brew --prefix openjdk 2>/dev/null)/libexec/openjdk.jdk/Contents/Home"
    if [ -d "$brew_jdk" ]; then
      JAVA_HOME_VALUE="$brew_jdk"
    fi
  fi
else
  if command -v java >/dev/null 2>&1; then
    JAVA_BIN="$(readlink -f "$(command -v java)")"
    JAVA_HOME_VALUE="$(dirname "$(dirname "$JAVA_BIN")")"
  fi
fi

if [ -n "$JAVA_HOME_VALUE" ]; then
  bakinfo "Detected JAVA_HOME as $JAVA_HOME_VALUE"
  for rc in "${RC_FILES[@]}"; do
    append_block "$rc" "Java setup (added by setup script)" <<EOF

# --- Java setup (added by setup script) ---
export JAVA_HOME="$JAVA_HOME_VALUE"
export PATH="\$JAVA_HOME/bin:\$PATH"
# --- end java setup ---
EOF
  done
else
  warn "Could not determine JAVA_HOME - skipping JAVA_HOME configuration."
fi
update_progress

info "Backing up neovim config..."
backup "${HOME}/.config/nvim"
update_progress

info "Linking neovim config files..."
mkdir -p "${HOME}/.config"  # Create .config directory if necessary.
cp -r "${HOME}/dotfiles/nvim" "${HOME}/.config"
update_progress

# fastfetch is not installed on macOS, so its config is only linked on Linux.
if [ "$OS" != "Darwin" ]; then
  info "Linking fastfetch config..."
  mkdir -p "${HOME}/.config"
  cp -r "${HOME}/dotfiles/fastfetch" "${HOME}/.config"
fi
update_progress

clear_progress
success "Done. You should restart your shell."