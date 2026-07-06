# Make ls list in columns, and append marker for type of file.
alias lsa='ls -aCF'

# Run updates and cleanup (package manager depends on OS)
if [ "$(uname -s)" = "Darwin" ]; then
    alias update='brew update && brew upgrade && brew cleanup'
else
    alias update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove --purge -y'
fi

# Print ssh public key
alias give-key='cat ${HOME}/.ssh/id_ed25519.pub'

# Alias bat for better cat.
# On Debian/Ubuntu the binary is 'batcat'; on macOS (Homebrew) it is 'bat'.
if [ "$(uname -s)" = "Darwin" ]; then
    alias bat='bat -P'
else
    alias bat='batcat -P'
fi

alias python='python3'

# tmux reload config
alias tmux-load='tmux source-file ~/.tmux.conf'