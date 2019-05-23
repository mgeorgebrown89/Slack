# Get the path the script is executing from
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here
# If the module is already in memory, remove it
Get-Module PSlickPSlack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
Import-Module .\PSlickPSlack.psm1 -Force 

Describe "New-SlackDividerBlock Unit Tests" -Tags "Unit" {
    Context "Slack Divider Block" {
        $divider = New-SlackDividerBlock
        It "has a type of divider" {
            $block.type | Should Be 'divider'
        }
    }
}