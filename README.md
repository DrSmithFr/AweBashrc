AweBash - Amplified Bashrc
==========================

Installation (Recommended)
--------------------------

 - Download AweBash 
 - Decompress AweBash where you want
 - Execute the following command:

        chmod +x install.sh && ./install.sh

 - Copy /config.sh.dist to /config.sh
 - Edit /config.sh as you want
 
Optional: 
---------

 - Install NVM (Node Version Manager) to manage your node versions
 - Install SymfonyCLI to manage your Symfony projects add php version
 - Install Composer to manage your PHP projects

Core Features:
--------------

 - Provide a clean prompt with git branch, git status.
 - Provide an `extract` command to extract any archive.

Core Aliases:
-------------

 - `grep|fgrep|egrep` : Execute with color by default
 - `o` : Execute `nautilus` in current folder
 - `c` : Execute `clear`
 - `r` : Execute `reset`
 - `t` : Execute `time`
 - `rt` : Execute `reset && time`
 - `rl` : Execute `reset && l`
 - `rm|cp|mv|mkdir` : Execute with --interactive option by default
 - `apt|aptitude` : Execute with sudo by default
 - `ap` : Execute a clean update of your system
 - `source` : Executed without arguments, will reload your AweBashrc
 - `sudo` : Executed with arguments, will switch to root user

Core Ls Aliases:
----------------

 - `ls` : Execute with `-h --color -l --group-directories-first` options by default
 - `l|la` : Provide a numerical view of permissions
 - `ld|lda` : Provide a numerical view of permissions with directories only
 - `lf|lfa` : Provide a numerical view of permissions with files only

Example:
```
total 36K
 775 drwxrwxr-x 5 john john 4,0K feb  6 21:51 cache
 775 drwxrwxr-x 4 john john 4,0K feb  7 11:07 core
 775 drwxrwxr-x 7 john john 4,0K dic 21 13:06 plugins
 664 -rw-rw-r-- 1 john john 3,8K feb  6 21:08 Awe.sh
 664 -rw-rw-r-- 1 john john 1,2K nov 13 11:44 LICENSE
 664 -rw-rw-r-- 1 john john 2,0K feb  7 00:28 README.md
 664 -rw-rw-r-- 1 john john   73 nov 13 11:44 config.sh
 664 -rw-rw-r-- 1 john john   52 nov 13 11:44 config.sh.dist
 775 -rwxrwxr-x 1 john john  386 nov 13 11:48 install.sh
```

Plugins
-------
- [AweCD](plugins/AweCD/README.md) : Amplified `cd` command
- [AweDocker](plugins/AweDocker/README.md) : Provide `docker` commands aliases
- [AweGit](plugins/AweGit/README.md) : Amplified `git` command and aliases
- [AweSymfony](plugins/AweSymfony/README.md) : Provide `symfony` commands aliases
- [AweSystemInfo](plugins/AweSystemInfo/README.md) : Provide System information aliases 
