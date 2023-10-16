#!/bin/bash

# Check if the system is running Ubuntu
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [ "$ID" = "ubuntu" ]; then
        echo "Ubuntu OS detected. Starting Apache hardening..."
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

echo "Starting Apache hardening..."

# Install Apache if not already installed
if ! command -v apache2 &>/dev/null; then
    apt update
    apt install -y apache2
fi

# Disable directory listing
echo "Options -Indexes" > /etc/apache2/conf-available/no-indexes.conf
a2enconf no-indexes

# Remove default Apache documentation
rm -rf /var/www/html/*

# Enable security headers, HSTS, and HTTP to HTTPS redirection
a2enmod headers
cat <<EOF > /etc/apache2/conf-available/security-headers.conf
Header always set X-Content-Type-Options "nosniff"
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-XSS-Protection "1; mode=block"
Header always set Content-Security-Policy "default-src 'self'"
Header always set Referrer-Policy "no-referrer"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
EOF
a2enconf security-headers

# Configure HTTP to HTTPS redirection
a2enmod rewrite
cat <<EOF > /etc/apache2/conf-available/https-redirect.conf
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
EOF
a2enconf https-redirect

# Disable SSL and configure TLS 1.2 and 1.3 only
a2dismod ssl
a2enmod ssl
cat <<EOF > /etc/apache2/conf-available/tls.conf
SSLProtocol -all +TLSv1.2 +TLSv1.3
EOF
a2enconf tls

# Remove Apache server version information
echo "ServerTokens Prod" >> /etc/apache2/apache2.conf
echo "ServerSignature Off" >> /etc/apache2/apache2.conf

# Disable PHP disclosure
echo "expose_php = Off" >> /etc/php/7.4/apache2/php.ini  # Change the PHP version as needed

# Restart Apache to apply changes
systemctl restart apache2

echo "Apache hardening complete."

