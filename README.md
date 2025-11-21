# Atlas setup script
This is my setup script for Ubuntu/Debian Linux systems.  

# Instructions
In your home directory, clone the repo, then run the setup script.
```
git clone https://github.com/AtlasICL/dotfiles ~/dotfiles
bash ./dotfiles/setup.sh
```
**Notes:**
- **You should modify** the `.gitconfig` in your home folder to with **your name and email**.
- NeoVim requires a nerd font. I use [this one](https://www.programmingfonts.org/#jetbrainsmono), 
it is free and open source.

# Features and behaviour

### Sanity checks
- Verifies script is running on an apt-based system.  
- Verifies sudo permissions.

### SSH
Generates an SSH key-pair if one doesn't exists on the machine.

### Updates
Updates all system packages.

### Developer tools
Installs the dev tools I use:
    - C/C++ compilers and debuggers.
    - Java/Maven, and sets JAVA_HOME.
    - Command line tools: fzf, ripgrep, fd-find.
    - NeoVim (and related config files from this repo).

### Backups
- The script will create **time-stamped backups** for any files it overwrites.  
- The backups can be found at `~/atlas-setup-backups/`

### Progress bar
- Just because I was feeling fancy (and it's in orange).


