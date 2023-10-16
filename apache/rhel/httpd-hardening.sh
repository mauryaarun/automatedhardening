#!/bin/bash

# Check if the system is running RHEL
if [ -f /etc/redhat-release ]; then
    release=$(cat /etc/redhat-release)
    if [[ "$release" == *"Red Hat Enterprise Linux"* ]]; then
        echo "RHEL detected. Starting Apache hardening..."
    else
        echo "This script is intended for RHEL. Exiting..."
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

echo "Starting Apache hardening..."

# Install Apache if not already installed
if ! command -v httpd &>/dev/null; then
    dnf install -y httpd
fi

# Disable directory listing
echo "Options -Indexes" > /etc/httpd/conf.d/no-indexes.conf

# Remove default Apache documentation
rm -rf /var/www/html/*

# Enable security headers, HSTS, and HTTP to HTTPS redirection
echo "LoadModule headers_module modules/mod_headers.so" >> /etc/httpd/conf.modules.d/00-security.conf
cat <<EOF > /etc/httpd/conf.d/security-headers.conf
Header always set X-Content-Type-Options "nosniff"
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-XSS-Protection "1; mode=block"
Header always set Content-Security-Policy "default-src 'self'"
Header always set Referrer-Policy "no-referrer"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"


RewriteEngine on
RewriteCond %{HTTP_COOKIE} !^.*HttpOnly; Secure; SameSite=Strict.*$ [NC]
RewriteRule ^ - [CO=Set-Cookie:%{HTTP_COOKIE};HttpOnly; Secure; SameSite=Strict:302=/$]


EOF

# Configure HTTP to HTTPS redirection
cat <<EOF > /etc/httpd/conf.d/https-redirect.conf
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
EOF

# Disable SSL and configure TLS 1.2 and 1.3 only
sed -i 's/SSLProtocol.*/SSLProtocol -all +TLSv1.2 +TLSv1.3/' /etc/httpd/conf.d/ssl.conf

# Remove Apache server version information
echo "ServerTokens Prod" >> /etc/httpd/conf/httpd.conf
echo "ServerSignature Off" >> /etc/httpd/conf/httpd.conf

# Disable PHP disclosure
sed -i 's/expose_php = On/expose_php = Off/' /etc/php.ini  # Check PHP configuration location

# Start and enable the Apache service
systemctl start httpd
systemctl enable httpd

echo "Apache hardening complete."

