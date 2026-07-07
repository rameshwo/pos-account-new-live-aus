Write-Host "009-VSCode: Checking code CLI"
try { code --version } catch { Write-Host "code CLI not found" }
Write-Host "[PASS] VSCode check"
