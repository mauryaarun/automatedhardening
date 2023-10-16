#!/bin/bash

# Check if the system is running Ubuntu
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [ "$ID" = "ubuntu" ]; then
        echo "Ubuntu OS detected. Starting hardening process..."
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

echo "Starting Ubuntu hardening..."

# Update package repositories and upgrade packages
apt update
apt upgrade -y

# Disable unnecessary services (example services provided)
services_to_disable=(
    "apache2"
    "telnet"
    "ftp"
    # Add more services to disable as needed
)

for service in "${services_to_disable[@]}"; do
    systemctl disable "$service"
    systemctl stop "$service"
done

# Set strong password policies (requires 'libpam-pwquality' package)
apt install -y libpam-pwquality
cat <<EOF >> /etc/security/pwquality.conf
minlen = 12
minclass = 3
EOF

# Lock accounts with no password
awk -F: '($2 == "") {print $1}' /etc/shadow | while read -r user; do
    passwd -l "$user"
done

# Configure firewall (UFW)
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw enable

ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
GENERATED_PUBLIC_KEY=$(cat ~/.ssh/id_ed25519.pub)


# SSH hardening
# Disable root login and password authentication
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Configure SSH to use key-based authentication
mkdir -p /root/.ssh
echo "$GENERATED_PUBLIC_KEY" > /root/.ssh/authorized_keys
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
service ssh restart

# Enable automatic security updates
apt install -y unattended-upgrades
dpkg-reconfigure --priority=low unattended-upgrades

# Regularly scan for malware (e.g., ClamAV)
apt install -y clamav
freshclam
clamscan -r /

# Secure GRUB bootloader configuration (set a GRUB password)
echo -e "Enter a GRUB password:"
grub-mkpasswd-pbkdf2 | tee /tmp/grub_password
grub_password=$(cat /tmp/grub_password)
echo "set superusers=\"root\"" >> /etc/grub.d/40_custom
echo "password_pbkdf2 root $grub_password" >> /etc/grub.d/40_custom
update-grub

# Enable auditd for auditing and monitoring (if not already installed)
apt install -y auditd
systemctl enable auditd
systemctl start auditd

# Additional hardening steps...

echo "Ubuntu hardening complete."


