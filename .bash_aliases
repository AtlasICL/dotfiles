# Make ls list in columns, and append marker for type of file.
alias lsa='ls -aCF'

# Confirm before deletion
alias rm='rm -i'

# Open ghostty and kill current terminal
alias ghost='GDK_BACKEND=wayland nohup ghostty /snap/bin/ghostty >/dev/null 2>&1 & disown; exit'

# Run updates and cleanup
alias update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove --purge -y'
