#!/usr/bin/env bash

export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch GIT_PS1_SHOWCOLORHINTS=1

# Default Colors
PS1_MAIN="${BRed}"
PS1_PATH="${BOrange}"
PS1_GIT="${BYellow}"

# source cache\prompt.color
if [[ -f "$AWE_INSTALL_FOLDER/cache/prompt.color" ]]
then
    source "$AWE_INSTALL_FOLDER/cache/prompt.color"
else
      echo "prompt.color not found"
fi

# root user
if [ "$(id -u)" = 0 ]
then
    PS1_MAIN="${ALERT}"
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1="\[${PS1_MAIN}\]┌─\[${NC}\]"
    PS1+="[\t] "
    PS1+="\[${PS1_MAIN}\]\u\[${NC}\]@\[${NC}\]\h\[${NC}\] "
    PS1+="(\[${PS1_PATH}\]\w\[${NC}\])"

    # affichage repo-git
    PS1+='$(__git_ps1 " '
    PS1+="[\[${PS1_GIT}\]%s\[${NC}\]]"
    PS1+='") '

    PS1+="\[${PS1_MAIN}\]──┤\n"
    PS1+="\[${PS1_MAIN}\]└┤\[${NC}\]\\$\[${PS1_MAIN}\]├─►\[${NC}\] "
else
    PS1="┌─[\t] \u]@\h (\w)"

    # affichage repo-git
    PS1+='$(__git_ps1 " '
    PS1+="[%s]"
    PS1+='") '

    PS1+="──┤\n└┤\\$├─► "
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

function prompt-config()
{
    bash "$AWE_INSTALL_FOLDER/prompt.config.sh"
}
