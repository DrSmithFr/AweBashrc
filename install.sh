#!/usr/bin/env bash

export AWE_INSTALL_FOLDER="$( command cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mv ~/.bashrc ~/.bashrc.bak
grep -vwE ". /home/john/Programmes/AweBash/Awe.sh" ~/.bashrc.bak > ~/.bashrc
echo ". $AWE_INSTALL_FOLDER/Awe.sh" >> ~/.bashrc
echo -e "Updating your .bashrs ${BGreen}OK${NC}"

git clone https://github.com/MrSmith777/AweCD plugins/AweCD
git clone https://github.com/MrSmith777/AweGit plugins/AweGit
git clone https://github.com/MrSmith777/AweDocker plugins/AweDocker
git clone https://github.com/MrSmith777/AweSymfony plugins/AweSymfony
git clone https://github.com/MrSmith777/AweSystemInfo plugins/AweSystemInfo
git clone https://github.com/MrSmith777/AweTheFuck plugins/AweTheFuck

export AWE_DEBUG="TRUE"
. "$AWE_INSTALL_FOLDER/Awe.sh"
export AWE_DEBUG=""