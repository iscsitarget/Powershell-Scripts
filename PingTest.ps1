$hosts = "host1", "host2", "host3" # replace with your list of hosts
$pingIntervalSeconds = 5 # time between each ping
$pingDurationSeconds = 60 # total time to ping

$results = @()
$endTime = (Get-Date).AddSeconds($pingDurationSeconds)

while ((Get-Date) -lt $endTime) {
  foreach ($host in $hosts) {
    $ping = Test-Connection -ComputerName $host -Count 1 -ErrorAction SilentlyContinue
    if ($ping) {
      $result = [PSCustomObject]@{
        Hostname = $host
        PingStatus = "Success"
        ResponseTimeMs = $ping.ResponseTime
        Timestamp = Get-Date
      }
    }
    else {
      $result = [PSCustomObject]@{
        Hostname = $host
        PingStatus = "Failed"
        ResponseTimeMs = 0
        Timestamp = Get-Date
      }
    }
    $results += $result
  }
  Start-Sleep -Seconds $pingIntervalSeconds
}

$results | Export-Csv -Path "ping_results.csv" -NoTypeInformation
