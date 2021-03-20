#!/bin/bash
set -e

APT="apt-get -qq"
sudo $APT update && sudo $APT upgrade
sudo $APT install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo $APT update
sudo $APT install docker-ce
sudo usermod -aG docker vagrant