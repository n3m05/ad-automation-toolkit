<#
.SYNOPSIS
Bulk creates Active Directory users from a CSV file.

.DESCRIPTION
Reads user data from a CSV file and creates users in Active Directory.
Supports dry-run mode, logging, and error handling.
#>

param (
    [Parameter(Mandatory)]
    [string]$CsvPath,

    [switch]$DryRun
)

Import-Module ActiveDirectory

$LogFile = "../logs/BulkUserCreation.log"

function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -Append -FilePath $LogFile
}

Write-Log "Script started."

try {
    $Users = Import-Csv $CsvPath

    foreach ($User in $Users) {
        $Username = $User.SamAccountName

        if ($DryRun) {
            Write-Log "DRY-RUN: Would create user $Username"
            continue
        }

        New-ADUser `
            -Name "$($User.FirstName) $($User.LastName)" `
            -GivenName $User.FirstName `
            -Surname $User.LastName `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@domain.local" `
            -AccountPassword (ConvertTo-SecureString $User.Password -AsPlainText -Force) `
            -Enabled $true

        Write-Log "Created user $Username"
    }
}
catch {
    Write-Log "ERROR: $_"
}

Write-Log "Script completed."
