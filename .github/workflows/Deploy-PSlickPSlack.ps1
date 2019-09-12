$releaseNotes = $env:RELEASE_NOTES
$moduleVersion = ($env:RELEASE_VERSION) -replace "v",""
Write-Host "ModuleVersion: $moduleVersion"
$manifestPath = Resolve-Path -Path "*\PSlickPSlack.psd1"
Update-ModuleManifest -ReleaseNotes $releaseNotes -Path $manifestPath -ModuleVersion $moduleVersion

Publish-Module -Path $Path -NuGetApiKey $env:PSGALLERY_TOKEN -Force