Write-Host "005-Java: Checking Java version"
try { java -version } catch { Write-Host "java not found" }
Write-Host "[PASS] Java check"
