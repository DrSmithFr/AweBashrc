#!/usr/bin/env bash

##############################################################
######################### Général ############################
##############################################################

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

# Necessary for programmable completion.
shopt -s extglob

# Disable options:
shopt -u mailwarn
unset MAILCHECK        # Don't want my shell to warn me of incoming mail.

# autocomplete ssh commands
complete -W "$(echo `cat $HISTFILE | egrep '^ssh ' | sort | uniq | sed 's/^ssh //'`;)" ssh

##############################################################
######################### Mes alias ##########################
##############################################################

#les CD
alias ~='cd ~'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

#grep color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#Les indispensables
alias o="nohup $EXPLORER $(pwd) 2>/dev/null"
alias c='clear'
alias r='reset'
alias rl="r && l"
alias u="cd .."
alias q="exit"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

alias h='history'
alias j='jobs -l'
alias which='type -a'

alias du='du -kh'
alias df='df -kTh'

# sudo
alias apt-get='sudo apt-get'
alias aptitude='sudo aptitude'

#Clean update
function ap()
{
    apt-get update &&
    apt-get upgrade &&
    apt-get dist-upgrade &&
    apt-get autoclean &&
    apt-get clean &&
    apt-get autoremove
    debclean
    sudo bash -c "command pear channel-update pear.php.net && command pear upgrade PEAR"
}

##############################################################
##################### Mes fonctions ##########################
##############################################################

function grep_dir()
{
    if [ -z "$1" ]
	then
	    echo "Usage: dir_grep [recherche] ([dir])"
        exit 1
    else
        recherche="$1"
    fi

    if [ -z "$2" ]
	then
        directory=$(pwd)
    else
        directory=$2
    fi

    grep -R -i "$recherche" -A 20 -B 20 "$AWE_INSTALL_FOLDERectory"
}

function charset()
{
    if [ -z "$1" ]
    then
        echo "No file selected"
    else
        chardet $1 | sed -e 's/.*:\s//' | cut -d' ' -f1
    fi
}

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

function ltree()
{
    if [ -z "$1" ]
    then
        ls -R $(pwd) | awk '/:$/&&f{s=$0;f=0}/:$/&&!f{sub(/:$/,"");s=$0;f=1;next}NF&&f{ print s"/"$0 }'
    else
        ls -R $1 | awk '/:$/&&f{s=$0;f=0}/:$/&&!f{sub(/:$/,"");s=$0;f=1;next}NF&&f{ print s"/"$0 }'
    fi

}

# Show the contents of a file, including additional useful info
function showfile()
{
    width=72
    for input
    do
        lines="$(wc -l < $input | sed 's/ //g')"
        chars="$(wc -c < $input | sed 's/ //g')"
        owner="$(ls -ld $input | awk '{print $3}')"
        echo "-----------------------------------------------------------------"
        echo "File $input ($lines lines, $chars characters, owned by $owner):"
        echo "-----------------------------------------------------------------"
        while read line
        do
            if [ ${#line} -gt $width ] ; then
                echo "$line" | fmt | sed -e '1s/^/  /' -e '2,$s/^/+ /'
            else
                echo "  $line"
            fi
        done < $input
        echo "-----------------------------------------------------------------"
        echo "File $input ($lines lines, $chars characters, owned by $owner):"
        echo "-----------------------------------------------------------------"
    done | more
}

# Make a backup before editing a file
function safe_edit() {
    cp $1 ${1}.backup && $EDITOR $1
}

#mkdir avec cd auto
function md()
{
    if [ ! -n "$1" ]; then
        echo "Enter a directory name"
    elif [ -d $1 ]; then
        echo "\`$1' already exists"
    else
        mkdir $1 && cd $1
    fi
}

# Ownership Changes { own file user }
function own() {
    if [ -z "$1" ]
	then
        userName=$USER
    else
        userName=$1
    fi

    if [ -z "$2" ]
	then
        directo=$(pwd)
    else
        directo=$2
    fi

    sudo chown -R "$userName:$userName" "$AWE_INSTALL_FOLDERecto";
}



#repeat une fonction toute les x seconde (usage: repeat TIME FUNCTON)
function repeat()
{
    local period
    period=$1; shift;
    while (true); do
        eval "$@";
    sleep $period;
    done
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