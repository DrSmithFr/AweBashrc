#!/usr/bin/env bash

export AWE_INSTALL_FOLDER="$( command cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# install dependencies
sudo apt update
sudo apt install -y curl wget htop speech-dispatcher

# install ctop (htop for containers)
if ! command -v ctop &> /dev/null
then
    sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
    sudo chmod +x /usr/local/bin/ctop
    echo -e "ctop ${BGreen}installed${NC}"
else
    echo -e "ctop ${BGreen}already installed${NC}"
fi

# install nvm
if ! command -v nvm &> /dev/null
then
  curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  nvm install node
  echo -e "nvm ${BGreen}installed${NC}"
else
  echo -e "nvm ${BGreen}already installed${NC}"
fi

# install symfony CLI
if ! command -v symfony &> /dev/null
then
  curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | sudo -E bash
  sudo apt install symfony-cli
  echo -e "symfony CLI ${BGreen}installed${NC}"
else
  echo -e "symfony CLI ${BGreen}already installed${NC}"
fi

# Update .bashrc
mv ~/.bashrc ~/.bashrc.bak
grep -vwE ". /home/john/Programmes/AweBash/Awe.sh" ~/.bashrc.bak > ~/.bashrc
echo ". $AWE_INSTALL_FOLDER/Awe.sh" >> ~/.bashrc
echo -e "Updating your .bashrs ${BGreen}OK${NC}"

# source Awe.sh
export AWE_DEBUG="TRUE"
. "$AWE_INSTALL_FOLDER/Awe.sh"
export AWE_DEBUG=""
