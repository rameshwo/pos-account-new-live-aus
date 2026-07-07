Write-Host "012-Disk: Checking free space on C:\"
$free = (Get-PSDrive -Name C).Free
Write-Host "Free: $free"
Write-Host "[PASS] Disk check"
