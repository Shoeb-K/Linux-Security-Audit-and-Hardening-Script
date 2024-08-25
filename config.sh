#!/bin/bash

# Define the path for the report file (shared with security_audit.sh)
REPORT_FILE="security_audit_report.txt"

# Custom Security Check: Ensure /etc/ssh/sshd_config has secure permissions
check_sshd_config_permissions() {
    echo "Checking permissions for /etc/ssh/sshd_config..." | tee -a $REPORT_FILE
    
    # Get the permissions of the file
    perms=$(stat -c "%a" /etc/ssh/sshd_config)
    
    # Expected permissions for the file (600)
    expected_perms="600"
    
    if [ "$perms" -ne "$expected_perms" ]; then
        echo "Warning: /etc/ssh/sshd_config permissions are not set to $expected_perms." | tee -a $REPORT_FILE
        echo "Current permissions: $perms" | tee -a $REPORT_FILE
    else
        echo "Permissions for /etc/ssh/sshd_config are secure." | tee -a $REPORT_FILE
    fi
    
    echo "-----------------------------------" >> $REPORT_FILE
}

