#!/bin/bash
set -e

# Install Docker
apt-get update
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

# Initialize Docker Swarm (manager)
if ! docker info | grep -q 'Swarm: active'; then
  docker swarm init
fi

# Output join command for worker
MANAGER_IP=$(hostname -I | awk '{print $1}')
JOIN_CMD=$(docker swarm join-token worker -q)
echo "docker swarm join --token $JOIN_CMD $MANAGER_IP:2377" > /tmp/worker-join.sh
chmod +x /tmp/worker-join.sh 