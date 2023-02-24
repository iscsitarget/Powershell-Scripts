# PingTest

Send an amount of pings to a list of hosts and log the results
Use pingtestgraph from my Python repo to graph the results

# CreateOU
Create OU's on Active Directory using a given list.
Optionally provide a csv path, default using OU.csv inside this folder.
Mandatory, provide AD DNS Path like so: -Path "DC=mydomain,DC=com"


# CreateADUsers
Create users on Active Directory using a given list. OU's need to exist before running script.
Optionally provide a csv path, default using users.csv inside this folder.
Mandatory, provide AD DNS Path like so: -Path "DC=mydomain,DC=com"


# CreateDHCPSubnets
Create DHCP Scopes on Windows Server using a given list. 
Optionally provide a csv path, default using DHCP.csv inside this folder.
Optionally provide a WDSServer IP
Optionally provide a boot image path, default using "Boot\x64\wdsnbp.com"
PS C:\> .\CreateDHCPSubnets.ps1 -csvPath "C:\dhcp.csv" -WDSServer 1.2.3.4


# CreateDHCPFailover
Setup DHCP failover for 2 servers.
DHCP Role needs to be installed on both and scopes must be configured on the primary DC

