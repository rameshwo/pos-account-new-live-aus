Write-Host "015-Summary: Gathering reports"
Get-ChildItem -Path ..\reports\* -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "Report: $($_.Name)" }
Write-Host "[PASS] Summary"
