#!/usr/bin/env bash

export AWE_INSTALL_FOLDER="$( command cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# update system
sudo apt -y update &&
sudo apt -y upgrade &&
sudo apt -y dist-upgrade &&
sudo apt -y autoclean &&
sudo apt -y clean &&
sudo apt -y autoremove

# install dependencies
sudo apt install -y curl wget htop speech-dispatcher

# enforce ssh agent
if [ ! -f ~/.ssh/id_rsa ]
then
    ssh-keygen -t rsa -b 4096 -C "AweBashrc" -f ~/.ssh/id_rsa -q -N ""
    echo -e "ssh key ${BGreen}generated${NC}"
else
    echo -e "ssh key ${BGreen}already generated${NC}"
fi

# install ctop (htop for containers)
if [ ! -f /usr/local/bin/ctop ]
then
    sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
    sudo chmod +x /usr/local/bin/ctop
    echo -e "ctop ${BGreen}installed${NC}"
else
    echo -e "ctop ${BGreen}already installed${NC}"
fi

# Install git completion
if [ ! -f ~/.git-completion ]
then
    wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O ~/.git-completion
    echo -e "git completion ${BGreen}installed${NC}"
else
    echo -e "git completion ${BGreen}already installed${NC}"
fi

# Install git prompt
if [ ! -f ~/.git-prompt ]
then
    wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O ~/.git-prompt
    echo -e "git prompt ${BGreen}installed${NC}"
else
    echo -e "git prompt ${BGreen}already installed${NC}"
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
grep -vwE ". $AWE_INSTALL_FOLDER/Awe.sh" ~/.bashrc.bak > ~/.bashrc
echo ". $AWE_INSTALL_FOLDER/Awe.sh" >> ~/.bashrc
echo -e "Updating your .bashrs ${BGreen}OK${NC}"

# source Awe.sh
export AWE_DEBUG="TRUE"
. "$AWE_INSTALL_FOLDER/Awe.sh"
export AWE_DEBUG=""

# lunch prompt config
./prompt.config.sh
