#!/bin/bash
set -e

# Install Java (required for Jenkins)
apt-get update
apt-get install -y openjdk-11-jre wget gnupg2 apt-transport-https lsb-release curl

# Add Jenkins repo and key
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list

# Install Jenkins
apt-get update
apt-get install -y jenkins

# Start Jenkins
systemctl enable jenkins
systemctl start jenkins

# Install Trivy
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main | tee /etc/apt/sources.list.d/trivy.list
apt-get update
apt-get install -y trivy
