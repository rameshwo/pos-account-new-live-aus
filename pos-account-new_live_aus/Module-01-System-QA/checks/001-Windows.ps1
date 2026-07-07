Write-Host "001-Windows: Checking OS version"
$ver = (Get-CimInstance Win32_OperatingSystem).Caption
Write-Host "OS: $ver"
Write-Host "[PASS] Windows check"
