$root = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Slack Channel Test" $env:SLACK_CHANNEL

#$result = Invoke-Pester -OutputFile "$root\PSlickPSlack.Tests.xml" -OutputFormat NUnitXML -PassThru

if ($result.failedCount -ne 0) { 
    $x = $result.failedCount
    Write-Error "Pester returned $x errors. Build aborted."
}