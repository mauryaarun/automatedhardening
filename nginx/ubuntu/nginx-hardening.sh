#!/bin/bash

# Check if the system is running Ubuntu
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [ "$ID" = "ubuntu" ]; then
        echo "Ubuntu OS detected. Starting Nginx hardening..."
    else
        echo "This script is intended for Ubuntu. Exiting..."
        exit 1
    fi
else
    echo "Unable to detect the operating system. Exiting..."
    exit 1
fi

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

echo "Starting Nginx hardening..."

# Install Nginx if not already installed
if ! command -v nginx &>/dev/null; then
    apt update
    apt install -y nginx
fi

# Remove Nginx server version information
echo "server_tokens off;" >> /etc/nginx/nginx.conf

# Configure security headers
cat <<EOF > /etc/nginx/conf.d/security-headers.conf
add_header X-Content-Type-Options "nosniff";
add_header X-Frame-Options "SAMEORIGIN";
add_header X-XSS-Protection "1; mode=block";
add_header Content-Security-Policy "default-src 'self'";
add_header Referrer-Policy "no-referrer";
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload";
EOF

# Enable TLS 1.2 and 1.3 only
cat <<EOF > /etc/nginx/conf.d/tls.conf
ssl_protocols TLSv1.2 TLSv1.3;
EOF

# Restart Nginx to apply changes
systemctl restart nginx

echo "Nginx hardening complete."

