<#
.SYNOPSIS
    Creates users on AD.

.DESCRIPTION
    Create users on Active Directory using a given list. OU's need to exist before running script.

.PARAMETER csvPath
    Optionally provide a csv path, default using users.csv inside this folder.

.PARAMETER Path
    Mandatory, provide AD DNS Path like so: -Path "DC=mydomain,DC=com"

.EXAMPLE
    PS C:\> .\CreateADUsers.ps1 -Path "DC=mydomain,DC=com" -csvPath "C:\users.csv"
    User <1> created.
    User <2> created.
    ...

.NOTES
    v0.1
#>

#Import-Module ActiveDirectory

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,
    [string]$csvPath = "users.csv"
)

# Check if the CSV file exists
if (Test-Path $csvPath) {

    $UserList = Import-Csv $csvPath
    foreach ($User in $UserList) {

        # Create a new User in Active Directory
        $OU = "OU=" + $User.Department + "," + $Path
        New-ADUser -Name "$($User.FirstName) $($User.LastName)" `
            -SamAccountName $User.Username `
            -UserPrincipalName $User.Email `
            -Path $OU `
            -AccountPassword (ConvertTo-SecureString $User.Password -AsPlainText -Force) `
            -Enabled $true `
            -Department $User.Department
        Write-Host "User $($User.Username) created."
    }
} else {
    Write-Error "The specified CSV file could not be found."
}