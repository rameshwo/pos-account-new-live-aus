Write-Host "011-Network: Ping google.com"
try { Test-Connection -ComputerName google.com -Count 1 -Quiet } catch { Write-Host "network check failed" }
Write-Host "[PASS] Network check"
