$releaseNotes = $env:RELEASE_NOTES
$moduleVersion = ($env:RELEASE_VERSION) -replace "v",""

Write-Host "ModuleVersion: $moduleVersion"
$manifestPath = Resolve-Path -Path "*\PSlickPSlack.psd1"
Update-ModuleManifest -ReleaseNotes $releaseNotes -Path $manifestPath -ModuleVersion $moduleVersion
$moduleFilePath = Resolve-Path -Path "*\PSlickPSlack.psm1"
$modulePath = Split-Path -Parent $moduleFilePath
Publish-Module -Path $modulePath -NuGetApiKey $env:PSGALLERY_TOKEN -Force