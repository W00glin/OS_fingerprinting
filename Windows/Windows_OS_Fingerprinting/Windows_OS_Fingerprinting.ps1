<#
.SYNOPSIS
This script gathers comprehensive system information from a Windows machine.

.DESCRIPTION
This script runs a series of commands to collect detailed system information,
including network connections, running processes, event logs, scheduled tasks,
installed software, system configuration, and more. It's designed to provide
a snapshot of the system's current state, which can be useful for system
administrators, security analysts, or during system audits.

.NOTES
Some commands may require administrative privileges to run successfully.
The script will attempt to run all commands regardless of privilege level,
but some may produce limited output or error messages if run without
sufficient permissions.
#>

# Create a timestamp and get the hostname for the filename
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$hostname = (Get-WmiObject Win32_ComputerSystem).Name
$outputFile = "DetailedSystemInfo_$hostname_$timestamp.txt"

# Function to run a command and write its output to the file
function Run-Command($command, $description) {
    "`n--- $description ---" | Out-File -Append $outputFile
    Invoke-Expression $command | Out-File -Append $outputFile
}

# Run commands and append results to the file

# Basic system information
Run-Command 'systeminfo | Select-String "OS Name","OS Version","System Type"' "Basic System Information"

# Current user and hostname
Run-Command 'whoami' "Current User"
Run-Command 'hostname' "Hostname"

# Network connections and configuration
Run-Command 'netstat -ano' "Active Network Connections (including PID)"
Run-Command 'Get-NetIPConfiguration | Format-List InterfaceAlias, IPv4Address, DNSServer' "Network Configuration"
Run-Command 'Get-NetFirewallRule | Where-Object Enabled -eq "True" | Format-Table Name, DisplayName, Direction, Action' "Enabled Firewall Rules"

# Running processes
Run-Command 'tasklist' "List of Running Processes"
Run-Command 'Get-Process | Select-Object ProcessName, Id, CPU | Sort-Object CPU -Descending | Select-Object -First 10' "Top 10 CPU-consuming Processes"

# Event logs
Run-Command 'Get-Eventlog -list' "Available Event Logs"
Run-Command 'Get-EventLog -LogName System -Newest 10 | Format-Table TimeGenerated, EntryType, Source, Message -AutoSize' "Latest 10 System Event Log Entries"

# Scheduled tasks
Run-Command 'schtasks /query /v /fo LIST' "Detailed List of Scheduled Tasks"
Run-Command 'Get-ScheduledTask | Where-Object {$_.State -ne "Disabled"} | Select-Object TaskName, State, LastRunTime | Format-Table' "Enabled Scheduled Tasks"

# Services
Run-Command 'net start' "Started Services"
Run-Command 'Get-Service | Where-Object {$_.Status -eq "Running"} | Format-Table Name, DisplayName, Status' "Running Services"

# User accounts
Run-Command 'Get-LocalUser | Format-Table Name, Enabled, LastLogon' "Local User Accounts"
Run-Command 'net user' "User Account Details"
# Note: The following command works only in domain-joined computers
# Run-Command 'net user /domain' "Domain User Accounts"
# Run-Command 'Get-ADUser -Filter * | Format-Table Name, Enabled' "Active Directory Users"

# Installed software
Run-Command 'wmic product get name,version' "Installed Software (WMI)"
Run-Command 'Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize' "Installed Software (Registry 32-bit)"
Run-Command 'Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize' "Installed Software (Registry 64-bit)"

# System updates
Run-Command 'Get-HotFix | Sort-Object InstalledOn -Descending | Format-Table HotFixID, Description, InstalledOn -AutoSize' "Installed Updates"

# Disk space
Run-Command 'Get-PSDrive -PSProvider FileSystem | Format-Table Name, Used, Free' "Disk Space"

# Shared folders
Run-Command 'net share' "Shared Folders"

# Autorun entries (requires Sysinternals Autorunsc tool)
# Run-Command 'Autorunsc /accepteula' "Autorun Entries"

# Alternative Data Streams (ADS) - Note: This can be resource-intensive on large file systems
# Run-Command 'gci -recurse | % { gi $_.FullName -stream * } | where stream -ne ":$Data"' "Files with Alternate Data Streams"

Write-Host "Detailed system information has been exported to $outputFile"
