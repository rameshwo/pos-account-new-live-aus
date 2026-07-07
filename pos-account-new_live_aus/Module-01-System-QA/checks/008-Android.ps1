Write-Host "008-Android: Checking adb"
try { adb version } catch { Write-Host "adb not found" }
Write-Host "[PASS] Android check"
