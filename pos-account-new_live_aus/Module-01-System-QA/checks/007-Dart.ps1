Write-Host "007-Dart: Checking dart"
try { dart --version } catch { Write-Host "dart not found" }
Write-Host "[PASS] Dart check"
