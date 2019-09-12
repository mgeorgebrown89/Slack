
$releaseNotes = $env:RELEASE_NOTES
$moduleVersion = ($env:RELEASE_VERSION) -replace "v",""
$moduleVersion = "0.0.8"
Write-Host "ModuleVersion: $moduleVersion"
$manifestPath = Resolve-Path -Path "*\PSlickPSlack.psd1"
Update-ModuleManifest -ReleaseNotes $releaseNotes -Path $manifestPath -ModuleVersion $moduleVersion
$Path = (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)))
Write-Host "Path: $Path"
Publish-Module -Path $Path -NuGetApiKey $env:PSGALLERY_TOKEN -Force