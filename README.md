# AD Automation Toolkit

A PowerShell-based automation toolkit for common Active Directory administrative tasks.
Designed for system administrators and helpdesk engineers.

## Features
- Bulk user creation from CSV
- Disable inactive user accounts
- Password resets with forced change
- User and group reporting
- Logging and error handling
- Dry-run support for safe testing

## Requirements
- Windows Server or workstation with RSAT
- PowerShell 5.1+
- ActiveDirectory module

## Scripts

### New-BulkADUsers.ps1
Creates users from a CSV file.

**How it works (line by line):**
- Imports the AD module
- Reads user data from CSV
- Loops through each record
- Creates users or simulates creation in dry-run mode
- Logs every action

**Example:**
```powershell
.\New-BulkADUsers.ps1 -CsvPath ../data/users.csv -DryRun

## CSV Format

The bulk user creation script expects a CSV file located in the `/data` directory.

Required columns:
- FirstName
- LastName
- SamAccountName
- Password

Example file:
`data/users.example.csv`

> To use your own CSV, copy `users.example.csv` and rename it to `users.csv`, then fill in your users.


## Development Notes

These scripts were developed on macOS and are intended to be executed on a
 Windows system with the ActiveDirectory module installed.

