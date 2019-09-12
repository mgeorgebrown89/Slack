Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
$releaseNotes = $env:RELEASE_NOTES
$moduleVersion = ($env:RELEASE_VERSION) -replace "v",""
Write-Host "ModuleVersion: $moduleVersion"
$manifestPath = Resolve-Path -Path "*\PSlickPSlack.psd1" -Verbose
Update-ModuleManifest -ReleaseNotes $releaseNotes -Path $manifestPath -ModuleVersion $moduleVersion -Verbose
$moduleFilePath = Resolve-Path -Path "*\PSlickPSlack.psm1" -Verbose
$modulePath = Split-Path -Parent $moduleFilePath -Verbose
$nuGetApiKey = $env:PSGALLERY_TOKEN
Publish-Module -Path $modulePath -NuGetApiKey $nuGetApiKey -Repository PSGallery -Verbose