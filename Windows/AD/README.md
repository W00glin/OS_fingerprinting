# Guide

This script will:

- Import the Active Directory module.
- Create a filename that includes the hostname and current date/time.
- Run each AD enumeration command and append its output to the text file.
- Generate an HTML report of all Group Policies.
- Display messages showing where the files have been saved.

The resulting text file will be named something like `HOSTNAME_AD_enum_20240724_120000.txt`, and a separate GPOReport.html file will be created for the Group Policy report.

Please note:

- This script requires the Active Directory module to be available on the machine where it's run.
- The user running the script must have appropriate permissions to execute these AD commands.
- Some commands might fail or provide limited information depending on the user's permissions.
- Be cautious when running AD enumeration scripts, as they can potentially expose sensitive information. 
- Ensure you have proper authorization before using such scripts in any environment.