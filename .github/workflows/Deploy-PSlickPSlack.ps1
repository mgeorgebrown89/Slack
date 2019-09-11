$tags = @("PowerShell", "Slack", "API")
$Path = (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path))) + "\PSlickPSlack"
$env:RELEASE_NOTES
#Publish-Module -Path $Path -NuGetApiKey $env:PSGALLERY_TOKEN -Tags $tags -Force