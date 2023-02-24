<#
.SYNOPSIS
    Setup DHCP failover for 2 servers.

.DESCRIPTION
    Install DHCP Failover for 2 Windows Servers. DHCP Role needs to be installed on both
    and scopes must be configured on the primary DC

.EXAMPLE
    PS C:\> .\CreateDHCPFailover.ps1 -Source DC1 -Destination DC2 -Secret "MySecret"
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