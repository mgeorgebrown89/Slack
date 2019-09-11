$root = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Slack Channel Test" $env:SLACK_CHANNEL

$token = $env:SLACK_TOKEN
$channel = $env:SLACK_CHANNEL

$Headers = @{
Authorization = "Bearer $token"
}

$Body = [PSCustomObject]@{
    channel = $channel
    text    = "Hello, from GitHub Actions!"
}

Invoke-RestMethod -Method Post -Uri 'https://slack.com/api/chat.postMessage' -Headers $Headers -ContentType 'application/json;charset=iso-8859-1' -Body ($Body | ConvertTo-Json -Depth 100)

#$result = Invoke-Pester -OutputFile "$root\PSlickPSlack.Tests.xml" -OutputFormat NUnitXML -PassThru

if ($result.failedCount -ne 0) { 
    $x = $result.failedCount
    Write-Error "Pester returned $x errors. Build aborted."
}