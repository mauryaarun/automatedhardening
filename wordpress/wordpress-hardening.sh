#!/bin/bash

# This script is a basic guideline for WordPress security hardening.
# Please adjust the configuration based on your specific requirements.

# Replace these variables with your own values
WORDPRESS_DIR="/var/www/html/wordpress"
WORDPRESS_DB_USER="your_db_user"
WORDPRESS_DB_PASSWORD="your_db_password"

# Ensure that WordPress is installed
if [ ! -e "$WORDPRESS_DIR/wp-config.php" ]; then
    echo "WordPress is not installed in the specified directory."
    exit 1
fi

# Prevent directory listing
echo "Options -Indexes" > "$WORDPRESS_DIR/.htaccess"

# Limit file permissions
find "$WORDPRESS_DIR" -type d -exec chmod 755 {} \;
find "$WORDPRESS_DIR" -type f -exec chmod 644 {} \;

# Protect wp-config.php
chmod 600 "$WORDPRESS_DIR/wp-config.php"

# Disable XML-RPC
echo "Disable XML-RPC"
echo "ErrorDocument 403 /path-to-wordpress/index.php" >> "$WORDPRESS_DIR/.htaccess"

# Secure wp-admin directory with .htpasswd (optional)
# htpasswd -bc /path-to-wordpress/.htpasswd username password
# Create .htaccess to restrict access to wp-admin
# echo "AuthType Basic" > "$WORDPRESS_DIR/wp-admin/.htaccess"
# echo "AuthName 'Restricted Area'" >> "$WORDPRESS_DIR/wp-admin/.htaccess"
# echo "AuthUserFile /path-to-wordpress/.htpasswd" >> "$WORDPRESS_DIR/wp-admin/.htaccess"
# echo "Require valid-user" >> "$WORDPRESS_DIR/wp-admin/.htaccess"

# Disable directory listing
echo "Options -Indexes" > "$WORDPRESS_DIR/wp-content/uploads/.htaccess"

# Regularly update WordPress, themes, and plugins
wp-cli core update --path="$WORDPRESS_DIR" --allow-root
wp-cli plugin update --all --path="$WORDPRESS_DIR" --allow-root
wp-cli theme update --all --path="$WORDPRESS_DIR" --allow-root

# Configure file and directory ownership and permissions as needed

echo "WordPress security hardening completed."

