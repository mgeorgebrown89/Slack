$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$testResults = Get-Content -Path "$root\PSlickPSlack.Tests.json" | ConvertFrom-Json
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

<details>
<summary><b>Failures</b></summary>
<br>
<table>
  <tr>
    <th colspan="3">Context</th>
  </tr>
  <tr>
    <th>Passed</th>
    <th>Name</th>
    <th>Country</th>
  </tr>
  <tr>
    <td>Alfreds Futterkiste</td>
    <td>Maria Anders</td>
    <td>Germany</td>
  </tr>
  <tr>
    <td>Centro comercial Moctezuma</td>
    <td>Francisco Chang</td>
    <td>Mexico</td>
  </tr>
  <tr>
    <td>Ernst Handel</td>
    <td>Roland Mendel</td>
    <td>Austria</td>
  </tr>
  <tr>
    <td>Island Trading</td>
    <td>Helen Bennett</td>
    <td>UK</td>
  </tr>
  <tr>
    <td>Laughing Bacchus Winecellars</td>
    <td>Yoshi Tannamuri</td>
    <td>Canada</td>
  </tr>
  <tr>
    <td>Magazzini Alimentari Riuniti</td>
    <td>Giovanni Rovelli</td>
    <td>Italy</td>
  </tr>
</table>

</details>

"@

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
