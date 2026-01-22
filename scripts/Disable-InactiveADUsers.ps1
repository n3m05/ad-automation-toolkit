<#
.SYNOPSIS
Disables Active Directory accounts inactive for a specified number of days.
#>

param (
    [int]$DaysInactive = 90,
    [switch]$DryRun
)

Import-Module ActiveDirectory
$LogFile = "../logs/DisableInactiveUsers.log"

function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -Append -FilePath $LogFile
}

$Date = (Get-Date).AddDays(-$DaysInactive)
$Users = Get-ADUser -Filter * -Properties LastLogonDate |
    Where-Object { $_.LastLogonDate -lt $Date -and $_.Enabled }

foreach ($User in $Users) {
    if ($DryRun) {
        Write-Log "DRY-RUN: Would disable $($User.SamAccountName)"
    } else {
        Disable-ADAccount $User
        Write-Log "Disabled $($User.SamAccountName)"
    }
}
