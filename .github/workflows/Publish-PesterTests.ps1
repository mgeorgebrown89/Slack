$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$root

$testsFolderPath = Split-Path -Parent (Split-Path -Parent $root)
$testsFolderPath = $testsFolderPath + "\Tests"
$testsFolderPath

& $testsFolderPath\ReportUnit.exe $root $root