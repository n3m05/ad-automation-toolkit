<#
.SYNOPSIS
Generates a report of users and their group memberships.
#>

Import-Module ActiveDirectory

$OutputFile = "../logs/UserGroupReport.csv"

$Users = Get-ADUser -Filter * -Properties MemberOf

$Report = foreach ($User in $Users) {
    $Groups = ($User.MemberOf | Get-ADGroup | Select-Object -ExpandProperty Name) -join ";"

    [PSCustomObject]@{
        Username = $User.SamAccountName
        Groups   = $Groups
    }
}

$Report | Export-Csv $OutputFile -NoTypeInformation
