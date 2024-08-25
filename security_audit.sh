#!/bin/bash

# Define the path for the report file
REPORT_FILE="security_audit_report.txt"

# Create or clear the report file
> $REPORT_FILE

# Source the configuration file for custom checks
if [ -f "config.sh" ]; then
    source config.sh
else
    echo "Configuration file 'config.sh' not found!" | tee -a $REPORT_FILE
    exit 1
fi

# Function to list all users and groups
list_users_and_groups() {
    echo "Listing users and groups..." | tee -a $REPORT_FILE
    echo "Users:" | tee -a $REPORT_FILE
    cut -d: -f1 /etc/passwd | tee -a $REPORT_FILE
    echo "Groups:" | tee -a $REPORT_FILE
    cut -d: -f1 /etc/group | tee -a $REPORT_FILE
}

# Function to check for users with UID 0 and non-standard users
check_uid_0_users() {
    echo "Checking for users with UID 0 (root privileges)..." | tee -a $REPORT_FILE
    awk -F: '$3 == 0 { print $1 }' /etc/passwd | tee -a $REPORT_FILE
}

# Function to check for users without passwords
check_users_without_passwords() {
    echo "Checking for users without passwords..." | tee -a $REPORT_FILE
    awk -F: '($2 == "" || $2 == "x") { print $1 }' /etc/shadow | tee -a $REPORT_FILE
}

# Function to scan for world-writable files and directories
check_world_writable() {
    echo "Scanning for world-writable files and directories..." | tee -a $REPORT_FILE
    find / -xdev -type f -perm -0002 -exec ls -l {} \; | tee -a $REPORT_FILE
    find / -xdev -type d -perm -0002 -exec ls -ld {} \; | tee -a $REPORT_FILE
}

# Function to check for SUID and SGID bits
check_suid_sgid() {
    echo "Checking for SUID and SGID bits..." | tee -a $REPORT_FILE
    find / -xdev -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} \; | tee -a $REPORT_FILE
}

# Function to list running services
list_services() {
    echo "Listing running services..." | tee -a $REPORT_FILE
    systemctl list-units --type=service --state=running | tee -a $REPORT_FILE
}

# Function to check for unnecessary services
check_unnecessary_services() {
    echo "Checking for unnecessary services..." | tee -a $REPORT_FILE
    # Example logic to list all services and manually review them
    systemctl list-units --type=service --state=running | tee -a $REPORT_FILE
    echo "Review the list above and disable any unnecessary services." | tee -a $REPORT_FILE
}

# Function to verify firewall status and rules
check_firewall() {
    echo "Checking firewall status and rules..." | tee -a $REPORT_FILE
    if command -v ufw &> /dev/null; then
        ufw status verbose | tee -a $REPORT_FILE
    elif command -v iptables &> /dev/null; then
        iptables -L -v -n | tee -a $REPORT_FILE
    else
        echo "No known firewall utility found!" | tee -a $REPORT_FILE
    fi
}

# Function to verify network configurations
check_network() {
    echo "Checking network configurations..." | tee -a $REPORT_FILE
    ip a | tee -a $REPORT_FILE
    netstat -tuln | tee -a $REPORT_FILE
}

# Function to check for security updates
check_security_updates() {
    echo "Checking for security updates..." | tee -a $REPORT_FILE
    if command -v apt-get &> /dev/null; then
        apt-get update && apt-get -s upgrade | tee -a $REPORT_FILE
    elif command -v yum &> /dev/null; then
        yum check-update | tee -a $REPORT_FILE
    else
        echo "No known package manager found!" | tee -a $REPORT_FILE
    fi
}

# Function to check logs for suspicious activity
check_logs() {
    echo "Checking logs for suspicious activity..." | tee -a $REPORT_FILE
    grep -i "failed\|error" /var/log/auth.log | tee -a $REPORT_FILE
}

# Function to perform server hardening steps
hardening_steps() {
    echo "Performing server hardening steps..." | tee -a $REPORT_FILE
    
    # Example: Secure SSH configuration
    echo "Securing SSH configuration..." | tee -a $REPORT_FILE
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl reload sshd

    # Example: Configure automatic updates
    echo "Configuring automatic updates..." | tee -a $REPORT_FILE
    apt-get install -y unattended-upgrades
    dpkg-reconfigure --priority=low unattended-upgrades
}

# Function to run custom security checks
run_custom_checks() {
    if type check_sshd_config_permissions &> /dev/null; then
        check_sshd_config_permissions
    else
        echo "Custom check function not found!" | tee -a $REPORT_FILE
    fi
}

# Function to generate a summary report
generate_report() {
    echo "Security audit and hardening completed. Report saved to $REPORT_FILE."
}

# Main function to execute the script tasks
main() {
    list_users_and_groups
    check_uid_0_users
    check_users_without_passwords
    check_world_writable
    check_suid_sgid
    list_services
    check_unnecessary_services
    check_firewall
    check_network
    check_security_updates
    check_logs
    hardening_steps
    run_custom_checks
    generate_report
}

# Run the main function
main

