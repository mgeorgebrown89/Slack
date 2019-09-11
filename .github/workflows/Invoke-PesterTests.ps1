$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$result = Invoke-Pester -OutputFile "$root\VEC.Tests.xml" -OutputFormat NUnitXML -PassThru

if ($result.failedCount -ne 0) { 
    $x = $result.failedCount
    Write-Error "Pester returned $x errors. Build aborted."
}