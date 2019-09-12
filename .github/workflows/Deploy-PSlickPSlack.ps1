Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
$releaseNotes = $env:RELEASE_NOTES
$moduleVersion = ($env:RELEASE_VERSION) -replace "v",""
Write-Host "ModuleVersion: $moduleVersion"
$manifestPath = Resolve-Path -Path "*\PSlickPSlack.psd1" -Verbose
Update-ModuleManifest -ReleaseNotes $releaseNotes -Path $manifestPath.Path -ModuleVersion $moduleVersion -Verbose
$moduleFilePath = Resolve-Path -Path "*\PSlickPSlack.psm1" -Verbose
$modulePath = Split-Path -Parent $moduleFilePath.Path -Verbose
$nuGetApiKey = $env:PSGALLERY_TOKEN
try{
    Publish-Module -Path $modulePath -NuGetApiKey $nuGetApiKey -Repository PSGallery -Verbose -ErrorAction  -Force
    Write-Host "PSlickPSlack Module Published!"
}
catch {
    throw $_
}