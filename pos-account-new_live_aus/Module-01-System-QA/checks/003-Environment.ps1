Write-Host "003-Environment: Checking PATH entries"
$paths = $env:PATH -split ';' | Where-Object { $_ -ne '' }
$paths | Select-Object -First 5 | ForEach-Object { Write-Host "PATH: $_" }
Write-Host "[PASS] Environment check"
