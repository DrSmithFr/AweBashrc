#!/usr/bin/env bash
cdwrapper() {
    # Auto select cd or cdnvm if nvm is installed
    if ! command -v nvm &> /dev/null; then
        command cd "$@"
    else
        cdnvm "$@"
    fi

    if [[ -d "$PWD/.git" ]]; then
        # Force git branch history
        git co --log
    fi
}

# Adding nvm
cdnvm() {
    command cd "$@" || return $?
    nvm_path=$(nvm_find_up .nvmrc | tr -d '\n')

    # If there are no .nvmrc file, use the default nvm version
    if [[ ! $nvm_path = *[^[:space:]]* ]]; then

        declare default_version;
        default_version=$(nvm version default);

        # If there is no default version, set it to `node`
        # This will use the latest version on your machine
        if [[ $default_version == "N/A" ]]; then
            nvm alias default node;
            default_version=$(nvm version default);
        fi

        # If the current version is not the default version, set it to use the default version
        if [[ $(nvm current) != "$default_version" ]]; then
            nvm use default;
        fi

    elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
        declare nvm_version
        nvm_version=$(<"$nvm_path"/.nvmrc)

        declare locally_resolved_nvm_version
        # `nvm ls` will check all locally-available versions
        # If there are multiple matching versions, take the latest one
        # Remove the `->` and `*` characters and spaces
        # `locally_resolved_nvm_version` will be `N/A` if no local versions are found
        locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

        # If it is not already installed, install it
        # `nvm install` will implicitly use the newly-installed version
        if [[ "$locally_resolved_nvm_version" == "N/A" ]]; then
            nvm install "$nvm_version";
        elif [[ $(nvm current) != "$locally_resolved_nvm_version" ]]; then
            nvm use "$nvm_version";
        fi
    fi
}

# CD with restoration of PWD
actual=$(pwd)
AWE_EXT_AWECD="$AWE_PLUGIN_CURRENT_CACHE_FOLDER/$USER"

if [ ! -d "$AWE_EXT_AWECD" ]
then
    mkdir -p "$AWE_EXT_AWECD"
fi

function bash_save_last_pwd()
{
    if [[ -f "$AWE_EXT_AWECD/.lastdir" ]]
    then
        rm -f "$AWE_EXT_AWECD/.lastdir"
    fi

    pwd > "$AWE_EXT_AWECD/.lastdir"
}

##############################################################
########################### USAGE ############################
##############################################################
opt=$1
shift
case $opt in
    --restore|-r)
            lastdir="$(cat $AWE_EXT_AWECD/.lastdir)">/dev/null 2>&1
            if [ -d "$lastdir" ]; then
                cdwrapper "$lastdir"
                export PWD=$(pwd);
            else
                echo -e "bash: cd: nothing to restore"
            fi
    ;;
    --save|-s)
        if [ -z "$1" ]
        then
            echo "Usage: rd [Nom_du_favoris]"
        else
            pwd > "$AWE_EXT_AWECD/.lastdir_$1"
            echo "Saved '$1' as cd alias to '$(pwd)'"
        fi
    ;;
    --load|-lo)
        if [ -f "$AWE_EXT_AWECD/.lastdir_$1" ]
        then
            lastdir="$(cat $AWE_EXT_AWECD/.lastdir_$opt)">/dev/null 2>&1
            if [ -d "$lastdir" ]; then
                cdwrapper "$lastdir"
                export PWD=$(pwd);
                bash_save_last_pwd
            else
                echo -e "bash: AweCD: $1: Aucun alias de ce type"
            fi
        else
            echo -e "bash: AweCD: $1: Aucun alias de ce type"
            exit 1
        fi
    ;;
    --help) command cd --help ;;
    *)
        if [ -z "$opt" ]
        then
            cdwrapper "$HOME" && ls -h --color -lv --group-directories-first | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print $0}'
            export PWD=$(pwd);
            bash_save_last_pwd
        else
            if [ -d "$opt" ]
            then
                cdwrapper $opt && ls -h --color -lv --group-directories-first | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print $0}'
                export PWD=$(pwd);
                bash_save_last_pwd
            else
                if [ -f "$AWE_EXT_AWECD/.lastdir_$opt" ]
                then
                    lastdir="$(cat $AWE_EXT_AWECD/.lastdir_$opt)">/dev/null 2>&1
                    if [ -d "$lastdir" ]; then
                        echo -e "Using AweCD alias '$opt' to '$lastdir'"
                        cdwrapper "$lastdir" && ls -h --color -lv --group-directories-first | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print $0}'
                        export PWD=$(pwd);
                        bash_save_last_pwd
                    else
                        echo "bash: cd: $opt: Aucun fichier, dossier ou alias de ce type"
                    fi
                else
                    echo "bash: cd: $opt: Aucun fichier, dossier ou alias de ce type"
                fi
            fi
        fi
    ;;
esac
