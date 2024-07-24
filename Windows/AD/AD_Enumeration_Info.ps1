<#
.SYNOPSIS
This script gathers comprehensive Active Directory information from a Windows machine.

.DESCRIPTION
This script runs a series of commands to collect detailed Active Directory information,
including domain details, password policies, users, computers, groups, and group policies.
It's designed to provide a snapshot of the Active Directory environment, useful for system
administrators and security analysts.

.NOTES
Some commands require the Active Directory module and sufficient permissions.
Ensure the Active Directory module is installed and imported on the machine running this script.
#>

# Import the Active Directory module
Import-Module ActiveDirectory

# Create a timestamp and get the hostname for the filename
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$hostname = (Get-WmiObject Win32_ComputerSystem).Name
$outputFile = "ADInformation_$hostname_$timestamp.txt"

# Function to run a command and write its output to the file
function Run-Command($command, $description) {
    "`n--- $description ---" | Out-File -Append $outputFile
    Invoke-Expression $command | Out-File -Append $outputFile
}

# Run commands and append results to the file

# View all AD commands
Run-Command 'Get-Command -Module ActiveDirectory' "All Active Directory Commands"

# Display Basic Domain Information
Run-Command 'Get-ADDomain' "Basic Domain Information"

# Get all Fine-Grained Password Policies
Run-Command 'Get-ADFineGrainedPasswordPolicy -filter *' "Fine-Grained Password Policies"

# Get Domain Default Password Policy
Run-Command 'Get-ADDefaultDomainPasswordPolicy' "Default Domain Password Policy"

# Get All AD Users in Domain
Run-Command 'Get-ADUser -Filter *' "All Active Directory Users"

# Get All Computers in Domain
Run-Command 'Get-ADComputer -filter *' "All Active Directory Computers"

# Get All Groups in Domain
Run-Command 'Get-ADGroup -filter *' "All Active Directory Groups"

# Get All Group Members
Run-Command 'Get-ADGroupMember -filter *' "All Group Members"

# Get Group Policy
Run-Command 'Get-GPO -filter *' "Group Policy Objects"

# Get Group Policy Report
Run-Command 'Get-GPOReport' "Group Policy Report"

Write-Host "Active Directory information has been exported to $outputFile"
