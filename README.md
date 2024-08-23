# Linux Security Audit and Hardening Script

## Overview

This project contains a Bash script that automates the security audit and hardening process for Linux servers. The script performs a comprehensive set of checks to identify security vulnerabilities and applies recommended hardening measures to ensure your server is secure and complies with best practices.

## Features

- **User and Group Audits**: Lists all users and groups, checks for users with root privileges, and identifies weak or missing passwords.
- **File and Directory Permissions**: Scans for world-writable files, verifies `.ssh` directory permissions, and reports files with SUID/SGID bits.
- **Service Audits**: Lists running services, checks for unauthorized services, and ensures critical services are configured properly.
- **Firewall and Network Security**: Verifies firewall status, reports open ports, and checks for insecure network configurations.
- **IP and Network Configuration Checks**: Identifies public and private IP addresses and ensures sensitive services are not exposed to the public.
- **Security Updates and Patching**: Checks for available security updates and configures automatic updates.
- **Log Monitoring**: Scans logs for suspicious activity, such as failed SSH login attempts.
- **Server Hardening**: Implements SSH key-based authentication, disables IPv6 if not needed, secures the bootloader, configures firewall rules, and sets up automatic security updates.
- **Custom Security Checks**: Allows for easy extension with custom security checks based on organizational policies.
- **Reporting and Alerting**: Generates a summary report of the security audit and hardening process and sends email alerts if critical issues are found.

## Requirements

- **Operating System**: Linux (Tested on Ubuntu and CentOS)
- **Permissions**: The script must be run with root privileges to perform the required checks and apply hardening measures.
- **Utilities**: The script uses standard Linux utilities like `awk`, `grep`, `find`, `iptables`, `netstat`, `systemctl`, and `ufw`.

## Installation

1. **Clone the Repository**: Clone this repository to your local machine using the following command:

   ```bash
   git clone https://github.com/yourusername/security-audit-script.git
   cd security-audit-script
   ```

2. **Make the Script Executable**: Ensure the script has execute permissions.

   ```bash
   chmod +x security_audit.sh
   ```

3. **Edit Configuration Files**: If you want to add custom security checks, edit the `config.sh` file to define your specific checks.

## Usage

### Running the Script

To run the script, execute the following command with root privileges:

```bash
sudo ./security_audit.sh
```

### Output

- **Report File**: The script generates a detailed report named `security_audit_report.txt` in the current directory. This report contains the results of all the checks performed and the hardening steps applied.

- **Alerts**: If configured, the script can send email alerts for critical vulnerabilities or misconfigurations. This requires `mail` or a similar utility to be installed and configured on your server.

## Customization

### Adding Custom Security Checks

To add custom security checks, edit the `config.sh` file included in this repository. This file is sourced by the main script and allows you to define additional checks specific to your organization's policies.

Example `config.sh`:

```bash
# Custom Security Check Example
custom_check_example() {
    echo "Running custom security check..." | tee -a $REPORT_FILE
    # Custom check logic here
    echo "Custom check complete." | tee -a $REPORT_FILE
}

# Add the custom check function to the run_custom_checks function
run_custom_checks() {
    custom_check_example
    # Add more custom checks as needed
}
```

### Configuring Automatic Updates

The script installs and configures `unattended-upgrades` for automatic security updates on Debian-based systems. For other distributions, you may need to modify the script to use the appropriate package manager and update tools.

## Important Notes

- **Testing**: Always test the script in a non-production environment before deploying it on live servers. This helps identify any potential issues and ensures the script behaves as expected.
- **Backup**: Before applying any hardening measures, it's crucial to back up your server configuration and data. Some changes, especially those related to firewall rules and SSH configuration, can affect server accessibility.
- **Manual Steps**: Some hardening steps, such as securing the GRUB bootloader, require manual intervention. Follow the instructions provided in the report or script output to complete these steps.

## Troubleshooting

- **Permissions Issues**: If you encounter permission denied errors, ensure you are running the script with root privileges.
- **Command Not Found**: If the script reports missing commands, install the required utilities using your package manager (e.g., `apt`, `yum`).

## Contributing

Contributions are welcome! If you have suggestions for improvements or additional features, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Contact

For questions or support, please contact khan.shoeb006@gmail.com or open an issue on GitHub.

This `README.md` file should provide a comprehensive guide to your script, making it easy for others to understand, use, and contribute to your project.
