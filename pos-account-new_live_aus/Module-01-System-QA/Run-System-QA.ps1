# Run-System-QA.ps1
# Entrypoint to run all checks and produce reports

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $scriptDir

Write-Host "Running Module-01 System QA checks..."

$checks = Get-ChildItem -Path .\checks\*.ps1 | Sort-Object Name
foreach ($c in $checks) {
    Write-Host "-- Running $($c.Name)"
    & $c.FullName
}

Write-Host "Checks completed. Reports are in .\reports\"

Pop-Location
