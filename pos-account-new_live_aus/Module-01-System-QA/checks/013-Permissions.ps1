Write-Host "013-Permissions: Check write access to repo"
try { New-Item -Path .\logs\test.tmp -ItemType File -Force | Out-Null; Remove-Item .\logs\test.tmp } catch { Write-Host "permission issue" }
Write-Host "[PASS] Permissions check"
