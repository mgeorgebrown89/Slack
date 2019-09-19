$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$result = Invoke-Pester -OutputFile "$root\PSlickPSlack.Tests.xml" -OutputFormat NUnitXML -PassThru -Show Fails
Write-Host "Root path: $root"
if ($result.failedCount -ne 0) { 
    $x = $result.failedCount
    Write-Error "Pester returned $x errors. Build aborted."
}
