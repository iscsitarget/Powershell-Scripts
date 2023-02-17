$ipList = "1.1.1.1", "8.8.8.8" # replace with your list of hosts
$pingCount = 200 # how many times to ping each host

$pingResults = @()

# Loop for every ping count
for ($i = 0; $i -lt $pingCount; $i++) {
    # Loop for every IP address
    foreach ($ip in $ipList) {
        # Ping the host
        $ping = Test-Connection -Count 1 -ComputerName $ip
        # Add detailed results to the ping results array
        $pingResults += [PSCustomObject]@{
            "IP" = $ping.Address
            "Source" = $ping.Source
            "Time" = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            "Latency (ms)" = $ping.Latency
        }
    }
    # Wait 1 second before the next ping
    Start-Sleep -Seconds 1
}

# Export the ping results to a CSV file
$pingResults | Export-Csv -Path "ping_results.csv" -NoTypeInformation
