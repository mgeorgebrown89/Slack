# If the module is already in memory, remove it
Get-Module PSlickPSlack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
Import-Module .\PSlickPSlack\PSlickPSlack.psm1 -Force 
$functionName = $MyInvocation.MyCommand -replace ".Tests.ps1",""

Describe "$functionName Unit Tests" -Tags "Unit" {
    Context "Slack Image Element unit tests" {
        It "g" {

        }
    }
}