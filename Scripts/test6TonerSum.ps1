# Define the printers and their IP addresses
$printers = @{
    'k92-fls-02\EXPLOPR01' = '10.0.224.46'
    'k92-fls-02\MTSPrinter' = '10.0.224.29'
    'k92-fls-02\APDPRINTER01' = '10.0.224.50'
    'k92-fls-02\ConstructionPrinter' = '10.0.224.37'
    'k92-fls-02\FPM-SHARPPR01' = '10.0.224.32'
    'k92-fls-02\800L-SHARPPR01' = '10.0.225.47'
    'k92-fls-02\MTSCoreShedPR01' = '10.0.225.119'
    'k92-fls-02\SupplyPrinter' = '10.0.224.42'
    'k92-fls-02\800LMobilePrinter01' = '10.0.224.47'
    'k92-fls-02\MaintenancePrinter' = '10.0.224.31'
    'k92-fls-02\ProcessPrinter' = '10.0.224.35'
    'k92-fls-02\AdminPrinter' = '10.0.224.41'
    'k92-fls-02\MobilePrinter' = '10.0.224.39'
    'k92-fls-02\CAPrinter' = '10.0.224.44'
    'k92-fls-02\MEDICSPRINTER' = '10.0.224.49'
    'k92-fls-02\OHSETPrinter' = '10.0.224.33'
    'k92-fls-02\MineTrainingPrinter' = '10.0.225.82'
    'k92-fls-02\K92HRTRAININGPR01' = '10.0.224.81'
}

# Function to get toner levels
function Get-TonerLevels {
    param (
        [hashtable]$printers
    )

    Write-Output "`n"

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

            # Check if the Printer is monchrome
            $isMonochrome = $cyanTonerLevel -eq $null -and $magentaTonerLevel -eq $null -and $yellowTonerLevel -eq $null
            # $isMonochrome = $null -eq $cyanTonerLevel -and $null -eq $magentaTonerLevel -and $null -eq $blackTonerLevel



            # Output toner levels            
            Write-Output "  $name ($ip)"
           
            Write-Host "  ......................................" -ForegroundColor Green

            if ($isMonochrome){
                Write-Host "        > Black Toner Level - $blackTonerLevel%" -ForegroundColor Yellow
            } else {
                Write-Host "      > Black Toner Level - $yellowTonerLevel%" -ForegroundColor Yellow
            Write-Host "      > Cyan Toner Level - $blackTonerLevel%" -ForegroundColor Yellow
            Write-Host "      > Magenta Toner Level - $cyanTonerLevel%" -ForegroundColor Yellow
            Write-Host "      > Yellow Toner Level - $magentaTonerLevel%" -ForegroundColor Yellow            
            }

            Write-Host "  ......................................" -ForegroundColor Green
            Write-Output "`n"
        
            # Check if any toner is completely finished
            if ($blackTonerLevel -eq 0) {
                Write-Host "      > Black toner is completely finished and needs replacing." -foregroundColor Magenta
            }
            if ($cyanTonerLevel -eq 0) {
                Write-Host "      > Cyan toner is completely finished and needs replacing." -foregroundColor Magenta
            }
            if ($magentaTonerLevel -eq 0) {
                Write-Host "      > Magenta toner is completely finished and needs replacing." -foregroundColor Magenta
            }
            if ($yellowTonerLevel -eq 0) {
                Write-Host "      > Yellow toner is completely finished and needs replacing." -foregroundColor Magenta
            }
        
        } catch {
            Write-Output "`n"
            Write-Host "Failed to retrieve toner levels for $name ($ip) `n" -foregroundColor Red
            Write-Output ""
        }
    }
}

# Call the function
Get-TonerLevels -printers $printers