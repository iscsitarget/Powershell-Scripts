<#
.SYNOPSIS
    Setup DHCP failover for 2 servers.

.DESCRIPTION
    Install DHCP Failover for 2 Windows Servers. DHCP Role needs to be installed on both
    and scopes must be configured on the primary DC

.PARAMETER csvPath
    Optionally provide a csv path, default using DHCP.csv inside this folder.

.PARAMETER WDSServer
    Optionally provide a WDSServer IP

.PARAMETER WDSBootProgram
    Optionally provide a csv path, default using "Boot\x64\wdsnbp.com"


.EXAMPLE
    PS C:\> .\CreateDHCPSubnets.ps1 -csvPath "C:\dhcp.csv" -WDSServer 1.2.3.4
    Scope <1> created.
    Scope <2> created.
    ...

.NOTES
    v0.1
#>



param(
    [Parameter(Mandatory=$true)]
    [string]$Source,
    [string]$Destination,
    [string]$Secret
)

$Scopes = Get-DhcpServerv4Scope -ComputerName $Source
$ScopeIds = @()
$Name = $Source + "-" + $Destination

foreach ($Scope in $Scopes) {
    $ScopeId = $Scope.ScopeId
    $ScopeIds += $ScopeId
    Write-Host "Adding scope $($Scope.Name) with id $ScopeId to list of scopes"
}

Add-DhcpServerv4Failover -ComputerName $Source `
-ScopeId $ScopeIds `
-PartnerServer $Destination `
-MaxClientLeadTime 0 `
-Name $Name `
-ServerRole Standby `
-SharedSecret $Secret

Write-Host "Configuring DHCP failover for scopes on $Source"