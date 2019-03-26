#!/usr/bin/env bash

actual=$(pwd)
AWE_EXT_AWECD="$AWE_PLUGIN_CURRENT_CACHE_FOLDER/$USER"

if [ ! -d "$AWE_EXT_AWECD" ]
then
    mkdir "$AWE_EXT_AWECD"
fi

##############################################################
########################### USAGE ############################
##############################################################
opt=$1
shift
case $opt in
    --save|-s)
        if [ -z "$1" ]
	    then
	        echo "Usage: rd [Nom_du_favoris]"
	    else
            pwd > "$AWE_EXT_AWECD/.lastdir_$1"
        fi
    ;;
    --load|-lo)
        if [ -f "$AWE_EXT_AWECD/.lastdir_$1" ]
        then
            lastdir="$(cat $AWE_EXT_AWECD/.lastdir_$opt)">/dev/null 2>&1
            if [ -d "$lastdir" ]; then
                command cd "$lastdir"
                export PWD=$(pwd);
            else
                echo -e "bash: cd: $1: Aucun favoris de ce type"
            fi
        else
            echo -e "bash: cd: $1: Aucun favoris de ce type"
            exit 1
        fi
    ;;
    --help) command cd --help ;;
    *)
        if [ -z "$opt" ]
        then
            command cd "$HOME" && ls -h --color -lv --group-directories-first | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print $0}'
            export PWD=$(pwd);
        else
            if [ -d "$opt" ]
            then
                command cd $opt && ls -h --color -lv --group-directories-first | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print $0}'
                export PWD=$(pwd);
            else
                if [ -f "$AWE_EXT_AWECD/.lastdir_$opt" ]
                then
                    lastdir="$(cat $AWE_EXT_AWECD/.lastdir_$opt)">/dev/null 2>&1
                    if [ -d "$lastdir" ]; then
                        command cd "$lastdir" && ls -h --color -lv --group-directories-first | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print $0}'
                        export PWD=$(pwd);
                    else
                        echo "bash: cd: $opt: Aucun fichier, dossier ou favoris de ce type"
                    fi
                else
                    echo "bash: cd: $opt: Aucun fichier, dossier ou favoris de ce type"
                fi
            fi
        fi
    ;;
esac



