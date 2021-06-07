#!/bin/bash
# bash -c "$(wget -q -O - https://raw.githubusercontent.com/sebavasile/cloud-init/master/init.sh)"
sudo timedatectl set-timezone UTC
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    mc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
apt-get install -y git
mkdir -p /app/ && cd /app

echo "Enter credentials to authenticate to Docker Hub"
read -p "Username: " DOCKER_USERNAME
read -s -p "Password: " DOCKER_PASSWORD
echo ""
docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

echo "Clone Github repository. Enter Github credentials if prompted\n"
git clone https://github.com/sebavasile/binance-updown-tokens-spread.git /app
mkdir -p /app/python-project/stats
echo "------------ READY TO RUN ------------"
echo "Run example: \n\n"
echo "docker run -d --name binance-spread-adaup-btcdown -v /app/python-project:/app sebavasile/python-binance --pairup ADAUPUSDT --pairdown BTCDOWNUSDT \
--profitpercent 0.5 --ordersize 1000 --statsfile docker-stats-ADAUP-BTCDOWN.txt --csvfiletrades docker-trades.csv"

