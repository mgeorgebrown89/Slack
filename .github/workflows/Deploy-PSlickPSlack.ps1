$Path = (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path))) + "\PSlickPSlack"
$releaseNotes = $env:RELEASE_NOTES
$moduleVersion = ($env:RELEASE_VERSION) -replace "v",""
Update-ModuleManifest -ReleaseNotes $releaseNotes -Path "$Path\PSlickPSlack.psd1" -ModuleVersion $moduleVersion

Publish-Module -Path $Path -NuGetApiKey $env:PSGALLERY_TOKEN -Force