$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$testResults = Get-Content -Path "$root\PSlickPSlack.Tests.json" | ConvertFrom-Json
#$testResults



$markdown = @"
# Pester Test Results


"@

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
