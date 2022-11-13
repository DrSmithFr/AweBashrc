#!/usr/bin/env bash

# enforce ssh agent
eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa

export AWE_INSTALL_FOLDER="$( command cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$AWE_INSTALL_FOLDER/config.sh"

function awe_debug()
{
    if [ "$AWE_DEBUG" == "TRUE" ]
    then
        return 0
    else
        return 1; //false
    fi
}

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# allow alias in within sudo command
alias sudo='sudo '

ulimit -S -c 0      # Don't want coredumps.
set -o notify
set -o noclobber
set -o ignoreeof

# 'Universal' completion function
COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}

NCPU=$(grep -c 'processor' /proc/cpuinfo)   # Number of CPUs
SLOAD=$(( 100*${NCPU} ))                    # Small load
MLOAD=$(( 200*${NCPU} ))                    # Medium load
XLOAD=$(( 400*${NCPU} ))                    # Xlarge load

# history
if [ ! -d "$AWE_INSTALL_FOLDER/cache/bash_history" ]
then
    mkdir -p "$AWE_INSTALL_FOLDER/cache/bash_history"
fi

if [ ! -f "$AWE_INSTALL_FOLDER/cache/bash_history/$USER.log" ]
then
    touch "$AWE_INSTALL_FOLDER/cache/bash_history/$USER.log"
fi

#unlimited bash history
export HISTFILESIZE=""
export HISTSIZE=""
export HISTFILE="$AWE_INSTALL_FOLDER/cache/bash_history/$USER.log"

# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups

# Section About
function about() {
cat "$AWE_INSTALL_FOLDER/README.md"
}

if awe_debug; then echo -e "\n Ultimate BashRc ${BYellow}LOADING${NC}"; fi

# Loading configuration files (overwrite plugins configurations)
for file in $(\ls "$AWE_INSTALL_FOLDER/core/config")
do
    if [ -f "$AWE_INSTALL_FOLDER/core/config/$file" ]
    then
        source "$AWE_INSTALL_FOLDER/core/config/$file"
        if awe_debug; then echo -e "   core/config/$file ${BGreen}OK${NC}"; fi
    fi
done

# Loading functions files
for file in $(\ls "$AWE_INSTALL_FOLDER/core/function")
do
    if [ -f "$AWE_INSTALL_FOLDER/core/function/$file" ]
    then
        source "$AWE_INSTALL_FOLDER/core/function/$file"
        if awe_debug; then echo -e "   core/function/$file ${BGreen}OK${NC}"; fi
    fi
done

# Loading General config
source "$AWE_INSTALL_FOLDER/core/General.sh"
if awe_debug; then echo -e "   core/General.sh ${BGreen}OK${NC}"; fi

if awe_debug; then echo -e " Ultimate BashRc ${On_Green}${BRed}CORE LOADED${NC}"; fi

# Loading plugins files
for dir in $(\ls "$AWE_INSTALL_FOLDER/plugins")
do
    if [ -f "$AWE_INSTALL_FOLDER/plugins/$dir/Loader.awe.sh" ]
    then
        AWE_PLUGIN_CURRENT_FOLDER="$AWE_INSTALL_FOLDER/plugins/$dir"
        AWE_PLUGIN_CURRENT_CACHE_FOLDER="$AWE_INSTALL_FOLDER/cache/$dir"
        if awe_debug; then echo -e "   plugins/$dir/Loader.awe.sh ${BGreen}OK${NC}"; fi
        source "$AWE_INSTALL_FOLDER/plugins/$dir/Loader.awe.sh"
    fi
done

if awe_debug; then echo -e " Ultimate BashRc ${On_Green}${BRed}FULLY LOADED${NC}\n"; fi

# restoring previous PWD
if [[ "$(pwd)" == "$(realpath ~)" ]]
then
    cd -r
fi
