<#
.SYNOPSIS
    Creates DHCP scopes on Windows Server.

.DESCRIPTION
    Create DHCP Scopes on Windows Server using a given list. 

.PARAMETER csvPath
    Optionally provide a csv path, default using DHCP.csv inside this folder.

.PARAMETER WDSServer
    Optionally provide a WDSServer IP

.PARAMETER WDSBootProgram
    Optionally provide a boot image path, default using "Boot\x64\wdsnbp.com"


.EXAMPLE
    PS C:\> .\CreateDHCPSubnets.ps1 -csvPath "C:\dhcp.csv" -WDSServer 1.2.3.4
    Scope <1> created.
    Scope <2> created.
    ...

.NOTES
    v0.1
#>

#Import-Module ActiveDirectory

param(
    [Parameter(Mandatory=$true)]
    [string]$csvPath = "DHCP.csv",
    [string]$WDSServer,
    [string]$WDSBootProgram = "Boot\x86\wdsnbp.com"
)

# Check if the CSV file exists
if (Test-Path $csvPath) {

    $Scopes = Import-Csv $csvPath
    foreach ($Scope in $Scopes) {

        # Create a new DHCP Scope
        # $Scope variables: Name,BeginScope,EndScope,SubnetMask,Gateway,DNS1,DNS2,ParentDomain
        Add-DhcpServerv4Scope -Name $Scope.Name -StartRange $Scope.BeginScope `
            -EndRange $Scope.EndScope `
            -SubnetMask $Scope.SubnetMask `
            -PassThru | `
        Set-DhcpServerv4OptionValue -Router $Scope.Gateway -DnsServer $Scope.DNS1,$Scope.DNS2 `
            -DnsDomain $Scope.ParentDomain

        if ($WDSServer) {
            Add-DhcpServerv4OptionValue -ScopeId $Scope.BeginScope `
                WDSServer $WDSServer -WDSBootProgram $WDSBootProgram
        }

        Write-Host "Scope $($Scope.Name) created."
    }
} else {
    Write-Error "The specified CSV file could not be found."
}