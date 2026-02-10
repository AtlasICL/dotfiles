# Make ls list in columns, and append marker for type of file.
alias lsa='ls -aCF'

# Run updates and cleanup
alias update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove --purge -y'

# Print ssh public key
alias give-key='cat ${HOME}/.ssh/id_ed25519.pub'

# Alias bat for better cat
alias bat='batcat -P'

# Alias cat to bat
alias cat='batcat -P'

alias python='python3'
