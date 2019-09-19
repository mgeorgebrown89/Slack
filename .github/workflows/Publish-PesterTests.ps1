$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$testResults = Get-Content -Path "$root\PSlickPSlack.Tests.json" | ConvertFrom-Json

$testResults

Invoke-RestMethod -Uri "https://api.github.com/repos/mgeorgebrown89/pslickpslack/pulls" -Method Get