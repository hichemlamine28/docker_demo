#!/bin/bash
#  Remove all existant docker installation if existant
sudo apt remove docker docker-engine docker.io -y
sudo apt update -y

# install docker using apt
sudo apt install docker.io -y

# Install docker-ce
sudo apt install apt-transport-https ca-certificates curl software-properties-common lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update -y
sudo apt install docker-ce -y

# Fix docker to run without sudo
sudo usermod -aG docker ${USER}
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker
sudo systemctl enable containerd.service
docker --version
newgrp docker

# Install docker-compose
sudo apt install docker-compose -y
docker-compose --version

# Install docker-machine
curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine


