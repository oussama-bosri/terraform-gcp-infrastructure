#!/bin/bash
set -e

# --- Jenkins Install ---
# Install Java (required for Jenkins) and git
apt-get update
apt-get install -y openjdk-17-jre wget gnupg2 apt-transport-https lsb-release curl unzip git

# Add Jenkins repo and key
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list

# Install Jenkins
apt-get update
apt-get install -y jenkins

# Start Jenkins
systemctl enable jenkins
systemctl start jenkins

# --- Nginx/SSL Setup ---
apt-get install -y nginx openssl

# Generate a self-signed certificate (valid for 1 year)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/jenkins.key \
  -out /etc/ssl/certs/jenkins.crt \
  -subj "/CN=jenkins"

# Configure Nginx as reverse proxy for Jenkins
cat > /etc/nginx/sites-available/jenkins <<"EOF"
server {
    listen 443 ssl;
    server_name _;

    ssl_certificate /etc/ssl/certs/jenkins.crt;
    ssl_certificate_key /etc/ssl/private/jenkins.key;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

ln -sf /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/jenkins
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx 