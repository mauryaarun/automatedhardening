Hardening a Red Hat Linux server involves configuring various security settings and practices to make it more resistant to security threats. 
Here are few guidelines and commands to harden a Red Hat Linux server:

1. **Update Packages:**
   ```bash
   sudo yum update
   ```

2. **Disable Unnecessary Services:**
   ```bash
   sudo systemctl disable <service>
   ```

3. **Set Strong Password Policies:**
   ```bash
   sudo passwd -x 90 -n 7 -w 7 <username>
   ```

4. **Enable SELinux:**
   ```bash
   sudo setenforce 1
   ```

5. **Configure Firewall:**
   ```bash
   sudo firewall-cmd --zone=public --permanent --remove-service=dhcpv6-client
   sudo firewall-cmd --zone=public --permanent --add-service=ssh
   sudo firewall-cmd --reload
   ```

6. **SSH Hardening:**
   - Disable root login: `sudo nano /etc/ssh/sshd_config`
     ```
     PermitRootLogin no
     ```
   - Disable password authentication: 
     ```
     PasswordAuthentication no
     ```
   - Use SSH keys for authentication.

7. **Limit sudo Access:**
   Edit the sudoers file: `sudo visudo`

   Example: Allow a user to execute only specific commands.
   ```
   username ALL=(ALL) /bin/command
   ```

8. **Use Strong Encryption for SSH:**
   ```bash
   sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
   ```

9. **SSH Idle Timeout:**
   ```bash
   echo "ClientAliveInterval 300" | sudo tee -a /etc/ssh/sshd_config
   echo "ClientAliveCountMax 0" | sudo tee -a /etc/ssh/sshd_config
   ```

10. **Install Fail2Ban:**
    ```bash
    sudo yum install fail2ban
    ```

11. **Use Password Policy:**
    ```bash
    sudo authconfig --passminlen=12 --passminclass=3 --update
    ```

12. **User and Group Ownership:**
    ```bash
    sudo chown root:root /etc/passwd
    sudo chown root:shadow /etc/shadow
    ```

13. **File Permissions:**
    ```bash
    sudo chmod 644 /etc/passwd
    ```

14. **Password Expiry:**
    ```bash
    sudo chage -M 90 -m 7 -W 7 <username>
    ```

15. **Lock Accounts with No Password:**
    ```bash
    sudo passwd -l <username>
    ```

16. **SELinux Policy:**
    ```bash
    sudo yum install -y selinux-policy-targeted
    ```

17. **Disable IPv6:**
    ```bash
    sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
    ```

18. **Secure Shared Memory:**
    ```bash
    echo "kernel.shmmax = 67108864" | sudo tee -a /etc/sysctl.conf
    echo "kernel.shmall = 4294967296" | sudo tee -a /etc/sysctl.conf
    ```

19. **Secure sysctl Parameters:**
    ```bash
    echo "net.ipv4.conf.default.rp_filter = 1" | sudo tee -a /etc/sysctl.conf
    ```

20. **Enable Automatic Security Updates:**
    ```bash
    sudo yum install -y yum-cron
    sudo systemctl enable yum-cron
    ```

21. **Disable Unused Network Protocols:**
    ```bash
    echo "install dccp /bin/true" | sudo tee -a /etc/modprobe.d/CIS.conf
    ```

22. **Install Intrusion Detection System (IDS):**
    ```bash
    sudo yum install -y rkhunter
    ```

23. **Protect the Bootloader:**
    - Set a GRUB password.
    - Disable editing of kernel parameters.

24. **Secure /tmp:**
    ```bash
    sudo echo "none /tmp tmpfs defaults,rw,nosuid,nodev,noexec,relatime" >> /etc/fstab
    ```

25. **Limit Core Dumps:**
    ```bash
    sudo echo "* hard core 0" >> /etc/security/limits.conf
    ```

26. **File Integrity Checking:**
    - Install AIDE or Tripwire for file integrity monitoring.
  
27. **Use Strong SSL/TLS Protocols:**
    - Update SSL/TLS configuration for web servers.
  
28. **Implement Proper Logging:**
    - Set up remote syslog servers.
  
29. **Harden NTP Configuration:**
    - Configure NTP to use a trusted time source.
  
30. **Restrict Root Access:**
    - Disable SSH login for the root user.
  
31. **Security Updates:**
    - Regularly apply security updates.
  
32. **Limit Kernel Module Loading:**
    - Use kernel module loading restrictions.

33. **Filesystem Mount Options:**
    - Set appropriate mount options in `/etc/fstab`.

34. **Use Two-Factor Authentication (2FA):**
    - Enable 2FA for SSH and other critical services.
  
35. **Install and Configure a Web Application Firewall (WAF):**
    - Implement a WAF for web servers.
  
36. **Set SSH Banner Message:**
    - Display a legal banner message.
  
37. **Audit and Monitor User Activities:**
    - Configure auditd for auditing.
  
38. **Disable Unused Network Ports:**
    - Use firewall rules to block unused ports.

39. **Secure GRUB Bootloader Configuration:**
    - Set the bootloader password.
  
40. **Periodic Scanning for Malware:**
    - Install and run periodic malware scans.

41. **Implement Network Segmentation:**
    - Separate critical systems from the public network.

42. **Regularly Review and Rotate Logs:**
    - Log rotation and monitoring.

43. **Enable Disk Encryption:**
    - Encrypt sensitive data and system disks.

44. **Use Strong Passwords for Service Accounts:**
    - Use complex passwords for service accounts.

45. **Configure Local Firewall Rules:**
    - Implement additional firewall rules as needed.

46. **Restrict Physical Access:**
    - Secure the server physically.

47. **Implement User Training:**
    - Educate users on security best practices.

48. **Regular Backups:**
    - Implement automated backups and test restores.

49. **Incident Response Plan:**
    - Develop an incident response plan.

50. **Regular Security Audits:**
    - Conduct regular security audits and assessments.

