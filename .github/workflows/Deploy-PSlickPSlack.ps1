Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
$releaseNotes = $env:RELEASE_NOTES
$moduleVersion = ($env:RELEASE_VERSION) -replace "v",""
Write-Host "ModuleVersion: $moduleVersion"

$manifestPath = Resolve-Path -Path "*\PSlickPSlack.psd1"
Write-Host "Manifest Path: $manifestPath"

Update-ModuleManifest -ReleaseNotes $releaseNotes -Path $manifestPath.Path -ModuleVersion $moduleVersion -Verbose

$moduleFilePath = Resolve-Path -Path "*\PSlickPSlack.psm1"
Write-Host "Module File Path: $moduleFilePath"

$modulePath = Split-Path -Parent $moduleFilePath
Write-Host "Module Path: $modulePath"

$nuGetApiKey = $env:PSGALLERY_TOKEN

try{
    Publish-Module -Path $modulePath -NuGetApiKey $nuGetApiKey -Verbose -Debug -ErrorAction Stop 
    Write-Host "PSlickPSlack Module Published!"
}
catch {
    throw $_
}