$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$testResults = Get-Content -Path "$root\PSlickPSlack.Tests.json" | ConvertFrom-Json

$testResults

$Body = @{
    body = "Will **markdown** be _formatted_?
    
    What about spaces and newlines?"
}
$Token = $env:GITHUB_TOKEN
Write-Host "Token: $Token"
$Uri = $env:GITHUB_PR_URI
Write-Host "Uri: $Uri"
$Headers = @{
    Authorization = "Bearer $Token"
}

Invoke-RestMethod -Uri $Uri -Method Post -Body ($Body | ConvertTo-Json) -Headers $Headers -ContentType "application/json"
