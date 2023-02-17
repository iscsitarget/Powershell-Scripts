# Define the hosts to ping and the number of times to ping it
$hosts = "10.0.200.2", "10.0.200.5", "1.1.1.1", "8.8.8.8"
$num_pings = 25

# Create a new directory for the report files
$timestamp = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
$report_dir = "report-$timestamp"
New-Item -ItemType Directory -Path $report_dir | Out-Null

# Ping each host x times and log the results to a separate CSV file
foreach ($host in $hosts) {
    # Open a CSV file to write the ping results to
    $csv_file_path = Join-Path $report_dir "ping_results_$host.csv"
    $csv_file = New-Item -ItemType File -Path $csv_file_path | Select-Object -ExpandProperty FullName
    $writer = New-Object System.IO.StreamWriter($csv_file)
    
    # Write the header row
    $writer.WriteLine("Ping number,Response Time (ms)")

    # Ping the host x times and log the results to the CSV file
    for ($i = 1; $i -le $num_pings; $i++) {
        # Run the ping command
        $ping_process = Start-Process -FilePath "ping" -ArgumentList "-n 1", $host -NoNewWindow -PassThru
        
        # Get the output and error streams
        $ping_output = $ping_process.StandardOutput.ReadToEnd()
        $ping_error = $ping_process.StandardError.ReadToEnd()

        # Parse the ping output to get the response time and status
        $response_time = $null
        foreach ($line in $ping_output.Split("`n")) {
            Write-Host $line
            if ($line.Contains("time=")) {
                $response_time = [double]$line.Split("time=")[1].Split(" ")[0]
            }
        }

        # Write the ping results to the CSV file
        $writer.WriteLine("$i,$response_time")

        # Add a delay of 1 second between pings
        Start-Sleep -Seconds 1
    }

    $writer.Dispose()

    Write-Host "Ping results for host $host saved to file $csv_file_path"
}

Write-Host "All ping results saved to directory $report_dir"
