Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

$releaseNotes = $env:RELEASE_NOTES
$moduleVersion = ($env:RELEASE_VERSION) -replace "v",""
Write-Host "ModuleVersion: $moduleVersion"

$manifestPath = Resolve-Path -Path "*\Slack.psd1"
#Write-Host "Manifest Path: $manifestPath"

Update-ModuleManifest -ReleaseNotes $releaseNotes -Path $manifestPath.Path -ModuleVersion $moduleVersion #-Verbose

$moduleFilePath = Resolve-Path -Path "*\Slack.psm1"
#Write-Host "Module File Path: $moduleFilePath"

$modulePath = Split-Path -Parent $moduleFilePath
#Write-Host "Module Path: $modulePath"

$nuGetApiKey = $env:PSGALLERY_TOKEN

try{
    Publish-Module -Path $modulePath -NuGetApiKey $nuGetApiKey -ErrorAction Stop -Force #-Debug
    Write-Host "The Slack PowerShell Module Version $moduleVersion has been Published to the PowerShell Gallery!"
}
catch {
    throw $_
}
