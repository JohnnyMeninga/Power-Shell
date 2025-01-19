# Define the printers and their IP addresses
$printers = @{
    'k92-fls-02\EXPLOPR01' = '10.0.224.46'
    'k92-fls-02\MTSPrinter' = '10.0.224.29'
    'k92-fls-02\APDPRINTER01' = '10.0.224.50'
    'k92-fls-02\ConstructionPrinter' = '10.0.224.37'
    'k92-fls-02\FPM-SHARPPR01' = '10.0.224.32'
    'k92-fls-02\800L-SHARPPR01' = '10.0.225.47'
    'k92-fls-02\MTSCoreShedPR01' = '10.0.225.119'
}

# Function to get toner levels and send email notifications
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

            # Output toner levels
            Write-Output "......................................"
            Write-Output "  $name ($ip)"
            Write-Output "      > Black Toner Level - $blackTonerLevel%"
            Write-Output "      > Cyan Toner Level - $cyanTonerLevel%"
            Write-Output "      > Magenta Toner Level - $magentaTonerLevel%"
            Write-Output "      > Yellow Toner Level - $yellowTonerLevel%"

            # Check if any toner is completely finished and send email notification
            
            if ($blackTonerLevel -eq 0) {
                Write-Output "Black toner is completely finished and needs replacing.`n"
            }
            if ($cyanTonerLevel -eq 0) {
                Write-Output "Cyan toner is completely finished and needs replacing.`n"
            }
            if ($magentaTonerLevel -eq 0) {
                Write-Output "Magenta toner is completely finished and needs replacing.`n"
            }
            if ($yellowTonerLevel -eq 0) {
                Write-Output "Yellow toner is completely finished and needs replacing.`n"
            }
           
            # return message if fail to query specified printer
        } catch {
            Write-Output "Failed to retrieve toner levels for $name ($ip)"
        }
    }
}

# Call the function
Get-TonerLevels -printers $printers