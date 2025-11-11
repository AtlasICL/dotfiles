# Make ls list in columns, and append marker for type of file.
alias lsa='ls -aCF'

# Confirm before deletion
alias rm='rm -i'

# Run updates and cleanup
alias update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove --purge -y'
