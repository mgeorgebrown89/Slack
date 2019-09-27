# If the module is already in memory, remove it
Get-Module Slack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
Import-Module $Global:SlackModulePath -Force 
$functionName = $MyInvocation.MyCommand -replace ".Tests.ps1",""

InModuleScope -ModuleName Slack {
    
}