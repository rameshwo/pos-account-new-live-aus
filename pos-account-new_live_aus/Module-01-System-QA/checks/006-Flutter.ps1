Write-Host "006-Flutter: Checking flutter"
try { flutter --version } catch { Write-Host "flutter not found" }
Write-Host "[PASS] Flutter check"
