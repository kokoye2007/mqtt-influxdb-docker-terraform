#!/usr/bin/env bash
echo "waiting 180 seconds for cloud-init to update /etc/apt/sources.list"
timeout 180 /bin/bash -c \
  'until stat /var/lib/cloud/instance/boot-finished 2>/dev/null; do echo waiting ...; sleep 1; done'
echo "running apt-get update ..."
cat /etc/apt/sources.list
sudo -E apt-get update

# Install Docker
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Get the Docker repo GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker Ubuntu repo
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get -y upgrade
sudo apt-get -y install docker-ce
sudo apt-get -y install bash-completion

# Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Get Data
sudo mkdir /srv/
cd /srv/
sudo tar xvzf /tmp/mqtt.ter.tgz 
sudo cp /tmp/.env ./.env

# Install Apps
sudo docker-compose --env-file /srv/.env build
sudo docker-compose --env-file /srv/.env up -d

# Start up enable
sudo cp mqtt-tester.service /etc/systemd/system/mqtt-tester.service
sudo systemctl enable mqtt-tester.service
