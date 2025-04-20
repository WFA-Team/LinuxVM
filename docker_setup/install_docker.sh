#!/bin/bash

sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release --assume-yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io --assume-yes
sudo usermod -aG docker $USER
newgrp docker
dos2unix create_offsets.sh
sudo apt-get install docker-compose-plugin