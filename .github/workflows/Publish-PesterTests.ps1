$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$testResults = Get-Content -Path "$root\PSlickPSlack.Tests.json" | ConvertFrom-Json
#$testResults

$DescribeGroups = $testResults.TestResult | Group-Object -Property Describe

$markdown = @()
foreach ($tr in $testResults.TestResult){
    $markdown += '| Passed | Name |'
    $markdown += '| --- | --- |'
    $markdown += '|' + $tr.Passed + '|' + $tr.Name + '|'
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

Invoke-RestMethod -Uri $Uri -Method Post -Body ($Body | ConvertTo-Json) -Headers $Headers -ContentType "application/json"
