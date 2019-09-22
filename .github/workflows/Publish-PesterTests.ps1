$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$testResults = Get-Content -Path "$root\PSlickPSlack.Tests.json" | ConvertFrom-Json
#$testResults

$DescribeGroups = $testResults.TestResult | Group-Object -Property Describe

$markdown = @'
Passed | Name
--- | ---

'@
foreach ($tr in $testResults.TestResult){
    if($tr.passed -eq 'True'){
        $passed = ":heavy_check_mark:"
    } 
    elseif ($tr.passed -eq 'False') {
        $passed = ":X:"
    }
    $name = $tr.Name
    $markdown += @"
 $passed | $name

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
