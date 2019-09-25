$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$result = Invoke-Pester -OutputFile "$root\Slack.Tests.xml" -OutputFormat NUnitXML -PassThru
$result | ConvertTo-Json -Depth 100 | Out-File -FilePath "$root\Slack.Tests.json"
Write-Host "Root path: $root"
if ($result.failedCount -ne 0) { 
    $x = $result.failedCount
    Write-Error "Pester returned $x errors. Build aborted."
}
