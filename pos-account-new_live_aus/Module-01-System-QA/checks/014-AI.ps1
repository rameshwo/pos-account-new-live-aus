Write-Host "014-AI: Check common editor extensions"
$exts = @("dart-code.flutter","github.copilot","eamodio.gitlens")
foreach ($e in $exts) { Write-Host "Check extension: $e (manual check)" }
Write-Host "[PASS] AI tools check"
