#!/usr/bin/env bash
function awecd_help() {
cat <<EOF
cd: cd [-L|[-P [-e]] [-@]] [dir]
Change the shell working directory.

Change the current directory to DIR.  The default DIR is the value of the
HOME shell variable.

The variable CDPATH defines the search path for the directory containing
DIR.  Alternative directory names in CDPATH are separated by a colon (:).
A null directory name is the same as the current directory.  If DIR begins
with a slash (/), then CDPATH is not used.

If the directory is not found, and the shell option `cdable_vars' is set,
the word is assumed to be  a variable name.  If that variable has a value,
its value is used for DIR.

Options:
  -L        force symbolic links to be followed: resolve symbolic
            links in DIR after processing instances of `..'
  -P        use the physical directory structure without following
            symbolic links: resolve symbolic links in DIR before
            processing instances of `..'
  -e        if the -P option is supplied, and the current working
            directory cannot be determined successfully, exit with
            a non-zero status
  -@        on systems that support it, present a file with extended
            attributes as a directory containing the file attributes

The default is to follow symbolic links, as if `-L' were specified.
`..' is processed by removing the immediately previous pathname component
back to a slash or the beginning of DIR.

Exit Status:
Returns 0 if the directory is changed, and if $PWD is set successfully when
-P is used; non-zero otherwise.

Options added by AweCD:
  --last|-      go to the last directory you were in
  --restore     restore the last directory in usage
  --save|-s     save passed argument as alias name to the current directory
  --list|-l     list all aliases with there directories
  --remove|-r   remove passed alias name
EOF
}


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
        if [[ -f "$AWE_EXT_AWECD/.previousdir" ]]
        then
            rm -f "$AWE_EXT_AWECD/.previousdir"
        fi

        mv "$AWE_EXT_AWECD/.lastdir" "$AWE_EXT_AWECD/.previousdir"
    fi

    pwd > "$AWE_EXT_AWECD/.lastdir"
}

##############################################################
########################### USAGE ############################
##############################################################
opt=$1
shift
case $opt in
    --last|-)
        if [[ -f "$AWE_EXT_AWECD/.previousdir" ]]
        then
            cdwrapper "$(cat "$AWE_EXT_AWECD/.previousdir")"
            bash_save_last_pwd
        else
            echo "No previous directory found"
        fi
    ;;
    --restore)
        if [[ -f "$AWE_EXT_AWECD/.lastdir" ]]
        then
          lastdir="$(cat $AWE_EXT_AWECD/.lastdir)">/dev/null 2>&1
          if [ -d "$lastdir" ]; then
              cdwrapper "$lastdir"
              export PWD=$(pwd);
          else
              echo -e "bash: cd: nothing to restore"
          fi
        else
            echo "$HOME" > "$AWE_EXT_AWECD/.lastdir"
            echo "$HOME" > "$AWE_EXT_AWECD/.previousdir"
            cdwrapper "$HOME"
            export PWD=$(pwd);
        fi
    ;;
    --save|-s)
        if [ -z "$1" ]
        then
            echo "Usage: cd [alias_name]"
        else
            pwd > "$AWE_EXT_AWECD/.alias_$1"
            echo "Saved '$1' as cd alias to '$(pwd)'"
        fi
    ;;
    --list|-l)
        echo "Liste des alias de cd :"
        for file in $AWE_EXT_AWECD/.alias_*
        do
            if [[ -d "$(cat $file)" ]]
            then
                echo -e "\e[0;34m$(basename $file | sed 's/.alias_//g')\e[m : $(cat $file)"
            else
                echo -e "\e[0;41m$(basename $file | sed 's/.alias_//g')\e[m : $(cat $file) \e[0;31m(directory not found)\e[m"
            fi
        done
    ;;
    --remove|-r)
      if [ -f "$AWE_EXT_AWECD/.alias_$1" ]
      then
          rm -f "$AWE_EXT_AWECD/.alias_$1"
          echo -e "bash: AweCD: $1: alias removed"
      else
          echo -e "bash: AweCD: $1: alias not found"
          exit 1
      fi
    ;;
    --help|-h) awecd_help ;;
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
                if [ -f "$AWE_EXT_AWECD/.alias_$opt" ]
                then
                    alias="$(cat $AWE_EXT_AWECD/.alias_$opt)">/dev/null 2>&1
                    if [ -d "$alias" ]; then
                        echo -e "Using AweCD alias '$opt' to '$alias'"
                        cdwrapper "$alias" && ls -h --color -lv --group-directories-first | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print $0}'
                        export PWD=$(pwd);
                        bash_save_last_pwd
                    else
                        echo "bash: cd: $opt: no such directory or alias"
                    fi
                else
                    echo "bash: cd: $opt: no such directory or alias"
                fi
            fi
        fi
    ;;
esac
