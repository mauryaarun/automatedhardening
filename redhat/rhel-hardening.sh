#!/bin/bash

# Check if the system is running Red Hat Enterprise Linux (RHEL)
if [ -f /etc/redhat-release ]; then
    echo "Red Hat Linux detected. Starting hardening process..."
else
    echo "This script is intended for Red Hat Linux. Exiting..."
    exit 1
fi

# Update packages
yum update -y

# Disable unnecessary services
services_to_disable=(
    "bluetooth"
    "cups"
    "avahi-daemon"
    "iscsi"
    "autofs"
    "rpcbind"
    "postfix"
    # Add more services to disable as needed
)

for service in "${services_to_disable[@]}"; do
    systemctl disable "$service"
    systemctl stop "$service"
done

# Set strong password policies
authconfig --passminlen=12 --passminclass=3 --update

# Lock accounts with no password
awk -F: '($2 == "") {print $1}' /etc/shadow | while read -r user; do
    passwd -l "$user"
done

# Set password expiration policy
chage -M 90 -m 7 -W 7 root

# Enable SELinux
setenforce 1
yum install -y selinux-policy-targeted

# Configure firewall
firewall-cmd --permanent --zone=public --remove-service=dhcpv6-client
firewall-cmd --permanent --add-service=ssh
firewall-cmd --reload

# SSH hardening (disable root login, password authentication, etc.)
# Capture the current username
CURRENT_USER=$(whoami)

# Configure SSH server for maximum security
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
echo "UsePAM no" >> /etc/ssh/sshd_config
echo "AllowUsers $CURRENT_USER" >> /etc/ssh/sshd_config

# Use SSH key-based authentication
mkdir -p /home/$CURRENT_USER/.ssh
chmod 700 /home/$CURRENT_USER/.ssh
ssh-keygen -t ed25519 -N 'your_passphrase' -f /home/$CURRENT_USER/.ssh/id_ed25519

# Append the contents of id_ed25519.pub to authorized_keys
cat /home/$CURRENT_USER/.ssh/id_ed25519.pub >> /home/$CURRENT_USER/.ssh/authorized_keys
chmod 600 /home/$CURRENT_USER/.ssh/authorized_keys

# Set a strong SSH key passphrase
# (If you haven't set a passphrase earlier)
# ssh-keygen -p -N 'your_passphrase' -f /home/$CURRENT_USER/.ssh/id_ed25519

# Restart SSH service to apply changes
systemctl restart sshd




# Disable IPv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

# Harden sysctl parameters
echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
sysctl -p

# Disable unused network protocols
echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install tipc /bin/true" >> /etc/modprobe.d/CIS.conf

# Enable automatic security updates
yum install -y yum-cron
systemctl enable yum-cron

# Set up a GRUB password
echo " Set up a GRUB password "
grub2-setpassword

# Lock down GRUB editing
echo "GRUB_DISABLE_RECOVERY='true'" >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# Secure /tmp directory
echo "none /tmp tmpfs defaults,rw,nosuid,nodev,noexec,relatime" >> /etc/fstab

# Limit core dumps
echo "* hard core 0" >> /etc/security/limits.conf

# Install and configure intrusion detection system (e.g., rkhunter)
yum install -y rkhunter
rkhunter --propupd

# Set SSH banner message
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config

# Regularly review and rotate logs (use logrotate)

# Implement 2FA for critical services

# Regularly scan for malware (e.g., ClamAV)

# Secure GRUB bootloader configuration (set a GRUB password)

# Implement network segmentation and firewall rules as needed

# Consider additional security measures, such as file integrity monitoring

# Implement incident response and security audit procedures

# Schedule regular backups and test restores

echo "Red Hat Linux hardening complete."

