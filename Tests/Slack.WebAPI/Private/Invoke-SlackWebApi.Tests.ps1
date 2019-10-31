# If the module is already in memory, remove it
Get-Module Slack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent ((Split-Path -Parent $MyInvocation.MyCommand.Path))))
$ModuleRoot = $repoRoot + "\Slack"
Import-Module $ModuleRoot -Force 

InModuleScope -ModuleName Slack {
    
}