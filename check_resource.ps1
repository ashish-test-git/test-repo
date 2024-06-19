$result = 1

$sysinfo = Systeminfo -fo CSV | ConvertFrom-Csv
$avlRam = $sysinfo.'Available Physical Memory'
$totRam = $sysinfo.'Total Physical Memory' 


$avlcpu = Get-Counter '\Processor(_Total)\% Processor Time'
$cpuUsage = [int32]$avlcpu.CounterSamples.CookedValue



# Split the string to separate numeric value and unit
$value, $unit = $avlRam.Split(" ")

# Remove commas (if any) from the numeric value
$avRam = $value.Replace(",", "")

# Try converting the value to integer and handle potential errors
try {
  # Convert to 32-bit integer (recommended for memory size)
  $newavlRam = [int32]$avRam
  Write-Host "Converted RAM value (MB): $newavlRam"
}
catch {
  Write-Error "Error: Could not convert '$avRam' to a 32-bit integer."
}

$value, $unit = $totRam.Split(" ")

# Remove commas (if any) from the numeric value
$toRam = $value.Replace(",", "")

try {
  # Convert to 32-bit integer (recommended for memory size)
  $newtotRam = [int32]$toRam
  Write-Host "Converted RAM value (MB): $newtotRam"
}
catch {
  Write-Error "Error: Could not convert '$toRam' to a 32-bit integer."
}


$perRam = [int32](($newavlRam / $newtotRam ) * 100)
$ramLimit = [int32]90
$cpuLimit = [int32]40

if($avlRam -gt $ramLimit) {

    echo "High Ram Usage, Cannot create VM"
    $result = -1

} else {

    if($cpuUsage -gt $cpuLimit) {

        echo "High CPU Usage, Cannot create VM"
        $result = -1
    }
}

exit $result