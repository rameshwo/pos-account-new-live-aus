function Write-Log {
    param([string]$Message)
    $ts = Get-Date -Format o
    "$ts - $Message" | Out-File -FilePath ..\logs\system.log -Append -Encoding utf8
}
