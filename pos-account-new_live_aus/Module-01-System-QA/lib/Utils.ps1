function Test-Command {
    param([string]$Name, [ScriptBlock]$Script)
    Write-Host "Testing: $Name"
    try { & $Script; return $true } catch { return $false }
}
