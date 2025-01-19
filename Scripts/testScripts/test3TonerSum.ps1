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

#    'Printer2' = '192.168.1.101'
#    'Printer3' = '192.168.1.102'


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
            $tonerLevel = $snmp.Get(".1.3.6.1.2.1.43.11.1.1.9.1.1") # OID for toner level
            Write-Output "$name ($ip): Toner Level - $tonerLevel%"
        } catch {
            Write-Output "Failed to retrieve toner level for $name ($ip)"
        }
    }
}

# Call the function
Get-TonerLevels -printers $printers