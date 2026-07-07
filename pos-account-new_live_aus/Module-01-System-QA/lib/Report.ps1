function Write-Report {
    param([string]$Line)
    $out = "$(Get-Date -Format o) - $Line"
    $out | Out-File -FilePath ..\reports\Report.txt -Append -Encoding utf8
}
