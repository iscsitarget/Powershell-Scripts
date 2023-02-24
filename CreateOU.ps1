<#
.SYNOPSIS
    Creates OU's on AD.

.DESCRIPTION
    Create OU's on Active Directory using a given list.

.PARAMETER csvPath
    Optionally provide a csv path, default using OU.csv inside this folder.

.PARAMETER Path
    Mandatory, provide AD DNS Path like so: -Path "DC=mydomain,DC=com"

.EXAMPLE
    PS C:\> .\CreateOU.ps1 -Path "DC=mydomain,DC=com" -csvPath "C:\ou.csv"
    OU <1> created.
    OU <2> created.
    ...

.NOTES
    v0.1
#>

#Import-Module ActiveDirectory

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,
    [string]$csvPath = "OU.csv"
)

# Check if the CSV file exists
if (Test-Path $csvPath) {

    $OUlist = Import-Csv $csvPath
    foreach ($OU in $OUlist) {

        # Create a new OU in Active Directory
        New-ADOrganizationalUnit -Name $OU.OUName -Path $Path
        Write-Host "OU $($OU.OUName) created."
    }
} else {
    Write-Error "The specified CSV file could not be found."
}