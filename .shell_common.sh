# Common shell configuration.
# Sourced by both bash (~/.bashrc) and zsh (~/.zshrc).
# Keep this POSIX-ish so it works in both shells.

# Source aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Source custom git commands
if [ -f ~/.git_commands_custom.sh ]; then
    . ~/.git_commands_custom.sh
fi

# Source custom tmux commands
if [ -f ~/.tmux_commands_custom.sh ]; then
    . ~/.tmux_commands_custom.sh
fi

# Run fastfetch on startup (except if running through ssh, or if not installed).
if [ -z "$SSH_CONNECTION" ] && command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi

# Custom function to navigate into a directory and open it in VS Code.
op () {
  if [ -z "$1" ]; then
    echo "Usage: op <dir>" >&2
    return 2
  fi
  cd "$1" && code .
}

# Custom function to get the size of a directory.
sizeofdir () {
  if [ "$#" -eq 0 ]; then
    echo "Usage: sizeofdir <dir> OPTIONAL[dir2 dir3 ...]" >&2
    return 2
  fi
  du -hs -- "$@"
}

# Custom function for quick clone of GitHub repo.
gitcl () {
  if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: gitcl <repo> OPTIONAL[path]" >&2
    return 2
  fi

  local repo="$1"
  local dest="${2-}"
  local url="git@github.com:AtlasICL/$repo"

  if [ -z "$dest" ]; then
    git clone -- "$url"
  else
    git clone -- "$url" "$dest"
  fi
}

export PATH="$HOME/.local/bin:$PATH"
