# Define the printers and their IP addresses
$printers = @{
    'k92-fls-02\EXPLOPR01' = '10.0.224.46'
}

# Function to get toner levels
function Get-TonerLevels {
    param (
        [hashtable]$printers
    )

    foreach ($printer in $printers.GetEnumerator()) {
        $ip = $printer.Value
        $name = $printer.Key
        try {
            $snmp = New-Object -ComObject olePrn.OleSNMP
            $snmp.Open($ip, "public", 2, 3000)

            # OIDs for toner levels
            $blackTonerOID = ".1.3.6.1.2.1.43.11.1.1.9.1.1"
            $cyanTonerOID = ".1.3.6.1.2.1.43.11.1.1.9.1.2"
            $magentaTonerOID = ".1.3.6.1.2.1.43.11.1.1.9.1.3"
            $yellowTonerOID = ".1.3.6.1.2.1.43.11.1.1.9.1.4"

            # Get toner levels
            $blackTonerLevel = $snmp.Get($blackTonerOID)
            $cyanTonerLevel = $snmp.Get($cyanTonerOID)
            $magentaTonerLevel = $snmp.Get($magentaTonerOID)
            $yellowTonerLevel = $snmp.Get($yellowTonerOID)

            # Debugging output
            Write-Output "$name ($ip): Raw Black Toner Level - $blackTonerLevel"
            Write-Output "$name ($ip): Raw Cyan Toner Level - $cyanTonerLevel"
            Write-Output "$name ($ip): Raw Magenta Toner Level - $magentaTonerLevel"
            Write-Output "$name ($ip): Raw Yellow Toner Level - $yellowTonerLevel"

            # Output toner levels
            Write-Output "$name ($ip): Black Toner Level - $blackTonerLevel%"
            Write-Output "$name ($ip): Cyan Toner Level - $cyanTonerLevel%"
            Write-Output "$name ($ip): Magenta Toner Level - $magentaTonerLevel%"
            Write-Output "$name ($ip): Yellow Toner Level - $yellowTonerLevel%"
        } catch {
            Write-Output "Failed to retrieve toner levels for $name ($ip)"
        }
    }
}

# Call the function
Get-TonerLevels -printers $printers