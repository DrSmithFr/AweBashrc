#!/usr/bin/env bash

##############################################################
######################### Général ############################
##############################################################

#unity
export LD_PRELOAD=/lib/x86_64-linux-gnu/libresolv.so.2

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify

# Fix keyboard input sometimes blocked when IBus is active
export IBUS_ENABLE_SYNC_MODE=1

##############################################################
######################### Mes alias ##########################
##############################################################

#grep color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#Les indispensables
alias o="nemo . 2>/dev/null"
alias c='clear'
alias r='reset'
alias t='time'
alias rt='reset && time'
alias rl="r && l"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

alias h='history'

# sudo
alias apt-get='sudo apt-get'
alias aptitude='sudo aptitude'

# Clean update
function ap()
{
    apt-get -y update &&
    apt-get -y upgrade &&
    apt-get -y dist-upgrade &&
    apt-get -y autoclean &&
    apt-get -y clean &&
    apt-get -y autoremove
    debclean
}

##############################################################
##################### Mes fonctions ##########################
##############################################################

function source()
{
    if [ -z "$@" ]
    then
        export AWE_DEBUG="TRUE"
        command source "$AWE_INSTALL_FOLDER/Awe.sh"
        export AWE_DEBUG=''
    else
        command source $@
    fi
}

# lecture colorée de logs
logview()
{
    ccze -A < $1 | less -R
}

# lecture colorée de logs en directfunction logview()
logtail()
{
    tail -f $1 | ccze
}

function sudo()
{
    command="$@"
    if [ -z "$command" ]; then
        command sudo -s
    else
        command sudo "$@"
    fi
}
