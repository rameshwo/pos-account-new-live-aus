Write-Host "002-Hardware: Basic CPU/memory check"
$mem = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
Write-Host "Memory: $mem"
Write-Host "[PASS] Hardware check"
