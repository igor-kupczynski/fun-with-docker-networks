#!/bin/bash
set -e

COMPOSE_VERSION="1.28.5"

APT="apt-get -qq"
sudo $APT update && sudo $APT upgrade
sudo $APT install apt-transport-https ca-certificates curl software-properties-common

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo $APT update
sudo $APT install docker-ce
sudo usermod -aG docker vagrant

# docker compose
sudo curl -s -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64 \
	-o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# various utils
sudo $APT install net-tools		# for `arp`