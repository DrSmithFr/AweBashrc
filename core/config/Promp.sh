#!/usr/bin/env bash

export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch GIT_PS1_SHOWCOLORHINTS=1

# affichage sympathique de la ligne de commande
if [ "$(id -u)" = 0 ]
then
    PS1="\[${ALERT}\]┌─"
    PS1+="\[${BBlack}\][\t] "
    PS1+="\[${BYellow}\]\u\[${NC}\]\[${ALERT}\]@\h "
    PS1+="(\[${BGreen}\]\w\[${NC}\]\[${ALERT}\])"

    # affichage repo-git
    PS1+='$(__git_ps1 " '
    PS1+="[\[${BYellow}\]%s\[${NC}\]\[${ALERT}\]]"
    PS1+='") '
    PS1+=""

    PS1+="──┤\[${NC}\]\n"
    PS1+="\[${ALERT}\]└┤\\$├─►\[${NC}\] "
else
    PS1="\[${BRed}\]┌─\[${NC}\]"
    PS1+="[\t] "
    PS1+="\[${BRed}\]\u\[${NC}\]@\[${NC}\]\h\[${NC}\] "
    PS1+="(\[${BOrange}\]\w\[${NC}\])"

    # affichage repo-git
    PS1+='$(__git_ps1 " '
    PS1+="[\[${BYellow}\]%s\[${NC}\]]"
    PS1+='") '

    PS1+="\[${BRed}\]──┤\n└┤\[${NC}\]\\$\[${BRed}\]├─►\[${NC}\] "
fi
