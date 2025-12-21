# Atlas setup script
This is my setup script for Ubuntu/Debian Linux systems.  

---

# Instructions
In your home directory, clone the repo, then run the setup script.
```
git clone https://github.com/AtlasICL/dotfiles ~/dotfiles
bash ~/dotfiles/setup.sh
```
- **You should modify** the `.gitconfig` in your home folder to with **your name and email**.
- NeoVim requires a nerd font. I use [this one](https://www.programmingfonts.org/#jetbrainsmono), 
it is free and open source.

# Features and behaviour
### Sanity checks
- Verifies script is running on an apt-based system.  
- Verifies sudo permissions.

### SSH  
- Generates an SSH key-pair if one doesn't exists on the machine.

### Updates  
- Updates all system packages.

### Developer tools  
- Installs C/C++ compilers and debuggers.
- Installs Java/Maven, and sets JAVA_HOME.
- Installs command line tools: fzf, ripgrep, fd-find.
- Installs NeoVim, and copies config files (from this repo).

### Backups
- The script will create **time-stamped backups** for any files it overwrites.  
- The backups can be found at `~/atlas-setup-backups/`

### Aliases
- Sets up aliases in .bashrc:
    - `rm = rm -i` for confirmation on rm.
    - `lsa = ls -aCF` for nicer ls.
    - `give-key = cat ${HOME}/.ssh/id_ed25519.pub` for ssh pubkey.
    - `update = sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove --purge -y` for
    one-liner updates.
    - As well as other necessary aliases for fd-find and ripgrep. 
- Some aliases are set up in a separate .bash_aliases file, which is then sourced in .bashrc.

### Custom functions
- Sets up my custom functions in .bashrc.
    - `sizeofdir <dir>` to get the size of a directory (recursive).
    - Accepts multiple arguments: `sizeofdir dir1 dir2 dir3`.
    - `op <dir>`, which is a custom function which navigates to a folder and opens it in VS Code.
    - Effectively, `op <dir>` = `cd <dir> && code .`

### Progress bar
- Just because I was feeling fancy (and it's in orange).

### Optional scripts
- `install_haskell.sh` to install Haskell toolchain.
- `install_prolog.sh` to install Prolog.
