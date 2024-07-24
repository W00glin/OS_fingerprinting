# Notes:

- Active Directory Module: Ensure that the Active Directory module is installed and imported on the system where this script is run.

- Permissions: Some commands may require administrative privileges or specific permissions in the Active Directory domain.

- `Get-ADGroupMember`: The script uses Get-ADGroupMember -filter *, but please note that Get-ADGroupMember does not support a -filter parameter. You may want to specify a group name or loop through groups obtained from Get-ADGroup.

- `Get-GPOReport`: The Get-GPOReport command usually requires parameters such as `-Name` or `-Guid` to specify which GPO to report on, as well as `-ReportType` and `-Path` to define the output format and location. Modify this command according to your specific needs.