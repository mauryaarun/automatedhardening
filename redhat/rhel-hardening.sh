#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Enable the firewall and configure it
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --zone=public --add-service=ssh
firewall-cmd --reload

# Disable unused services
systemctl disable postfix
systemctl stop postfix
systemctl disable rpcbind
systemctl stop rpcbind

# Set user and group ownership on sensitive files
chown root:root /etc/passwd
chown root:root /etc/shadow
chown root:root /etc/group
chown root:root /etc/gshadow

# Set proper permissions on sensitive files
chmod 644 /etc/passwd
chmod 400 /etc/shadow
chmod 644 /etc/group
chmod 400 /etc/gshadow

# Configure password policy
authconfig --passminlen=12 --passminclass=3 --update

# Lock accounts with no passwords
passwd -l $(awk -F: '($2 == "") {print $1}' /etc/shadow)

# Set password expiration policy
chage -M 90 -m 7 -W 7 root

# Install and configure SELinux
yum install -y selinux-policy-targeted
setenforce 1

# Update the system
yum update -y

# Enable automatic security updates
yum install -y yum-cron
systemctl enable yum-cron
systemctl start yum-cron

# Configure SSH to use key-based authentication
#sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
#systemctl restart sshd
echo "Create a normal user, disabling root login.."
# Disable root login via SSH
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

# Configure sudo access
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers.d/wheel

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

# Reboot the system to apply changes
reboot
