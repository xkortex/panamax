#!/bin/bash
# Sets up the host from a fresh Ubuntu X.04 install

## Things prone to change
_URL_DOCKER_APT=https://download.docker.com/linux/ubuntu
_URL_DOCKER_GPG="${_URL_DOCKER_APT}/gpg"
_URL_COMPOSE=https://github.com/docker/compose/releases/download/1.24.0/docker-compose
_FINGERPRINT_DOCKER=0EBFCD88

sudo apt update
sudo apt install -y \
    git \
    zsh \
    tmux \
    curl \
    wget \
    nmap \
    htop \
    jq \
    arp-scan \
    traceroute \
    openssh-server \
    apt-transport-https \
    ca-certificates \
    build-essential \
    pkg-config \
    gnupg-agent \
    software-properties-common

# docker repo keys
curl -fsSL ${_URL_DOCKER_GPG} | sudo apt-key add -
sudo apt-key fingerprint ${_FINGERPRINT_DOCKER}
sudo add-apt-repository \
	"deb [arch=amd64] ${_URL_DOCKER_APT} \
	$(lsb_release -cs) stable"

sudo apt update
sudo apt install -y \
	docker-ce docker-ce-cli containerd.io


# Create the docker group
sudo groupadd docker
# add the current user to the docker group
sudo usermod -aG docker $USER

# Download and install Docker compose
sudo curl -L "${_URL_COMPOSE}"-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

