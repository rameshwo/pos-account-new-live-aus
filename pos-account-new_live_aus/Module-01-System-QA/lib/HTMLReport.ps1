function Generate-HTMLReport {
    param([string]$sourceText = "..\\reports\\Report.txt")
    $html = "<html><body><pre>" + (Get-Content $sourceText -Raw) + "</pre></body></html>"
    $html | Out-File -FilePath ..\reports\Report.html -Encoding utf8
}
