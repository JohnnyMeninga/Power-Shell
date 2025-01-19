$ipAddress = "10.0.235.136"  # Replace with the IP address of the target device
$arpTable = arp -a | Select-String $ipAddress
$macAddress = $arpTable -replace '.*?([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2}).*', '$1$2'
Write-Output "MAC Address of {$ipAddress}: $macAddress"