#!/bin/bash

set -e

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt-cache policy docker-ce
sudo apt install -y docker-ce

sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker
sudo usermod -aG docker ${USER}


# Installing Docker Compose
compose_plugin=$HOME/.docker/cli-plugins/docker-compose
compose_version=v2.0.1
compose_url=https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-linux-x86_64

curl -L --create-dirs --output $compose_plugin $compose_url
chmod +x $compose_plugin


