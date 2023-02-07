#!/usr/bin/env bash

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

function my_ip_public() # Get IP adress on ethernet.
{
    PUBLIC=$(wget -qO - icanhazip.com)
    echo ${PUBLIC:-"Not connected"}
}

function my_ip_local()
{
    local _ip _line
    while IFS=$': \t' read -a _line ;do
        [ -z "${_line%inet}" ] &&
        _ip=${_line[${#_line[1]}>4?1:2]} &&
        [ "${_ip#127.0.0.1}" ] && echo $_ip && return 0
    done< <(LANG=C /sbin/ifconfig)
}

# Get current host related info.
function ii()
{
    #echo -e "\nYou are logged on ${BRed}$HOST"
    echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
    echo -e "\n${BRed}User(s) logged on:$NC " ; w -hs |
             cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Current date :$NC " ; date
    echo -e "\n${BRed}Machine stats [ CPU:"$(load_color;load)"${BRed}% Disk:"$(disk_color)"${BRed}% ] :$NC " ; uptime
    echo -e "\n${BRed}Memory stats :$NC " ; free
    echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
    echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
    echo
}
function info_start()
{
    echo -e "${BRed}[${BYellow}"$(uname -n)"${BRed}] System information:$NC " ; uname -omvs ;
    echo -e "Uptime : $NC" $(uptime | sed 's/.*up \([^,]*\), .*/\1/' | tr ':' 'h')"min"
    echo -e "CPU    : " $(load_color;load)"%$NC"
    echo -e "Disk   : " $(disk_color)"%$NC"
    echo -e "\n${BRed}"$(w -hs | cut -d " " -f1 | sort | uniq | grep -c .)" Users logged on:$NC " ; w -hs |
             cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Public IPv4 Address : $NC\n"$(my_ip_public)
    echo -e "${BRed}Local  IPv4 Address : $NC\n"$(my_ip_local)
    echo
}

#recupère le denier argument passe en param (utile pour les script usage: $(last_arg "$@") )
function last_arg() {
    if [[ $# -ne 0 ]] ; then
        shift $(expr $# - 1)
        echo "$1"
        #else
        #do something when no arguments
    fi
}

# Returns system load as percentage, i.e., '40' rather than '0.40)'.
function load()
{
    local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
    # System load of the current host.
    echo $((10#$SYSLOAD))       # Convert to decimal.
}

# Returns a color indicating system load.
function load_color()
{
    local SYSLOAD=$(load)
    if [ ${SYSLOAD} -gt 100 ]; then
        echo -en ${ALERT}
    elif [ ${SYSLOAD} -gt 400 ]; then
        echo -en ${Red}
    elif [ ${SYSLOAD} -gt 800 ]; then
        echo -en ${BRed}
    else
        echo -en ${Green}
    fi
}

# Returns a color according to free disk space in $PWD.
function disk_color()
{
    if [ ! -w "${PWD}" ] ; then
        echo -en ${Red}
        # No 'write' privilege in the current directory.
    elif [ -s "${PWD}" ] ; then
        local used=$(command df -P "$PWD" |
                   awk 'END {print $5} {sub(/%/,"")}')
        if [ ${used} -gt 95 ]; then
            echo -en ${ALERT}${used}          # Disk almost full (>95%).
        elif [ ${used} -gt 90 ]; then
            echo -en ${BRed}${used}           # Free disk space almost gone.
        else
            echo -en ${Green}${used}          # Free disk space is ok.
        fi
    else
        echo -en ${Cyan}
        # Current directory is size '0' (like /proc, /sys etc).
    fi

}

# Returns a color according to running/suspended jobs.
function job_color()
{
    if [ $(jobs -s | wc -l) -gt "0" ]; then
        echo -en ${BRed}
    elif [ $(jobs -r | wc -l) -gt "0" ] ; then
        echo -en ${BCyan}
    fi
}