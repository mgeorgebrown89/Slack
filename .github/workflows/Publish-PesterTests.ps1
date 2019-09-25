$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$testResults = Get-Content -Path "$root\Slack.Tests.json" | ConvertFrom-Json
#$testResults
$total = $testResults.TotalCount
$passed = $testResults.PassedCount
$failed = $testResults.FailedCount
$skipped = $testResults.SkippedCount
$pending = $testResults.PendingCount
$inconclusive = $testResults.InconclusiveCount
$markdown = @"
| Total | Passed | Failed | Skipped | Pending | Inconclusive |
| --: | --: | --: | --: | --: | --: |
| $total | $passed | $failed | $skipped | $pending | $inconclusive |
"@

foreach ($tr in $testResults.TestResult){
    if($tr.passed -eq 'True'){
        $passed = ":heavy_check_mark:"
    } 
    elseif ($tr.passed -eq 'False') {
        $passed = ":X:"
        $name = $tr.Name
        $markdown += @"
     $passed | $name
    }
"@
}

$Body = @{
    body = $markdown
}

$Token = $env:GITHUB_TOKEN
#Write-Host "Token: $Token"
$Uri = $env:GITHUB_PR_URI
#Write-Host "Uri: $Uri"
$Headers = @{
    Authorization = "Bearer $Token"
}

Invoke-RestMethod -Uri $Uri -Method Post -Body ($Body | ConvertTo-Json -Depth 100) -Headers $Headers -ContentType "application/json"
