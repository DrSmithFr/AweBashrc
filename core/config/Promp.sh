#!/usr/bin/env bash

export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch GIT_PS1_SHOWCOLORHINTS=1

if [ "$(id -u)" = 0 ]
then
    cTrait=${BRed}
else
    cTrait=${BGreen}
fi

PS1="\[${cTrait}\]┌────\[${NC}\]"

# affichage sympathique de la ligne de commande
if [ "$(id -u)" = 0 ]
then
    PS1+="\[${ALERT}\][\t]\[${White}\] \[${BRed}\]\u\[${NC}\]@\[${NC}\]\h\[${NC}\]: (\[${BGreen}\]\w\[${NC}\]) "
else
    PS1+="[\t] \[${BYellow}\]\u\[${NC}\]@\[${NC}\]\h\[${NC}\]: (\[${BGreen}\]\w\[${NC}\])"
fi

# affichage repo-git
PS1+='$(__git_ps1 " '
PS1+="[\[${BYellow}\]%s\[${NC}\]]"
PS1+='") '
PS1+="\[${cTrait}\]──┤\n└┤\[${NC}\]\\$\[${cTrait}\]├──►\[${NC}\] "