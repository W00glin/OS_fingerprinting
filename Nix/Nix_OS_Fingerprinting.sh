#!/bin/bash

# Create a timestamp and get the hostname for the filename
timestamp=$(date +"%Y%m%d_%H%M%S")
hostname=$(cat /etc/hostname)
outputFile="SystemInformation_${hostname}_${timestamp}.txt"

# Function to run a command and write its output to the file
function run_command {
    echo -e "\n--- $2 ---\n" >> $outputFile
    $1 >> $outputFile 2>&1
}

# Start of the script

# Network connections and services
run_command "netstat -anp" "Active Network Connections (netstat)"
run_command "ss -anp" "Active Network Connections (ss)"

# Running processes
run_command "ps aux" "List of Running Processes (ps aux)"
run_command "ps -ef" "List of Running Processes (ps -ef)"

# System logs
run_command "cat /var/log/syslog" "System Log (/var/log/syslog)"

# Scheduled tasks
run_command "crontab -l" "Crontab for Current User"
run_command "crontab -u root -l" "Crontab for Root User"

# Services status
run_command "service --status-all 2>/dev/null | grep +" "Active Services"
run_command "initctl list | grep running" "Running Upstart Services"

# System identification
run_command "cat /etc/hostname" "Hostname"
run_command "uname -a" "System Information"
run_command "lsb_release -a" "Distribution Information"

# User and security information
run_command "cat /etc/passwd" "User Accounts (/etc/passwd)"
run_command "cat /etc/shadow" "Shadow Passwords (/etc/shadow)"

# Installed software
run_command "apt list --installed" "Installed Packages (APT)"

# Firewall configuration
run_command "iptables -L -n -v" "Firewall Rules (iptables)"
run_command "iptables -t nat -L -n -v" "NAT Rules (iptables)"

# Network shares
run_command "smbclient -L localhost -U%" "Samba Shares (localhost)"
run_command "showmount -e 127.0.0.1" "NFS Shares (localhost)"

echo "System information has been exported to $outputFile"
