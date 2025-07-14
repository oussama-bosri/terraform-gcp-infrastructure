#!/bin/bash
set -e

# Install Java (required for Jenkins and SonarQube)
apt-get update
apt-get install -y openjdk-17-jre wget gnupg2 apt-transport-https lsb-release curl unzip

# --- Jenkins Install ---
# Add Jenkins repo and key
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list

# Install Jenkins
apt-get update
apt-get install -y jenkins

# Start Jenkins
systemctl enable jenkins
systemctl start jenkins

# --- SonarQube Install ---
# Add SonarQube user
if ! id sonar &>/dev/null; then
  groupadd --system sonar
  useradd -s /bin/bash --system -g sonar sonar
fi

# Download and extract SonarQube
SONAR_VERSION=10.4.1.88267
cd /opt
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip
unzip sonarqube-$SONAR_VERSION.zip
mv sonarqube-$SONAR_VERSION sonarqube
chown -R sonar:sonar /opt/sonarqube

# Create systemd service for SonarQube
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

# --- Trivy Install ---
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main | tee /etc/apt/sources.list.d/trivy.list
apt-get update
apt-get install -y trivy
