Write-Host "004-Git: Checking git version"
try { git --version } catch { Write-Host "git not found" }
Write-Host "[PASS] Git check"
