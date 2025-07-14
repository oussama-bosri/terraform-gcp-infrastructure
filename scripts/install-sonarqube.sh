#!/bin/bash
set -e

# Install Java (required for SonarQube)
apt-get update
apt-get install -y openjdk-17-jre wget unzip

# Add SonarQube user
groupadd --system sonar
useradd -s /bin/bash --system -g sonar sonar

# Download and extract SonarQube
SONAR_VERSION=10.4.1.88267
cd /opt
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip
unzip sonarqube-$SONAR_VERSION.zip
mv sonarqube-$SONAR_VERSION sonarqube
chown -R sonar:sonar /opt/sonarqube

# Create systemd service
cat <<EOF > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=simple
User=sonar
Group=sonar
PermissionsStartOnly=true
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
Restart=always
LimitNOFILE=65536
LimitNPROC=4096
TimeoutStartSec=5
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start SonarQube
systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube 