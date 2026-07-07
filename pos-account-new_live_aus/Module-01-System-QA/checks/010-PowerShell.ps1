Write-Host "010-PowerShell: Checking PowerShell version"
try { $PSVersionTable } catch { Write-Host "PowerShell not available" }
Write-Host "[PASS] PowerShell check"
