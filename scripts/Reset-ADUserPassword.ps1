<#
.SYNOPSIS
Resets a user's password and forces change at next logon.
#>

param (
    [Parameter(Mandatory)]
    [string]$Username,

    [Parameter(Mandatory)]
    [string]$NewPassword,

    [switch]$DryRun
)

Import-Module ActiveDirectory
$LogFile = "../logs/PasswordReset.log"

function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -Append -FilePath $LogFile
}

if ($DryRun) {
    Write-Log "DRY-RUN: Would reset password for $Username"
    exit
}

Set-ADAccountPassword `
    -Identity $Username `
    -Reset `
    -NewPassword (ConvertTo-SecureString $NewPassword -AsPlainText -Force)

Set-ADUser -Identity $Username -ChangePasswordAtLogon $true

Write-Log "Password reset for $Username"
