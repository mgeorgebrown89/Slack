# If the module is already in memory, remove it
Get-Module Slack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent ((Split-Path -Parent $MyInvocation.MyCommand.Path)))))
$ModuleRoot = $repoRoot + "\Slack"
Import-Module $ModuleRoot -Force 

$slackContent = Get-Content $ModuleRoot\SlackDefaults.json | ConvertFrom-Json
$SlackUri = $slackContent.slackwebhook
$SlackHeaders = @{Authorization = ("Bearer " + $slackContent.slacktoken) }

InModuleScope -ModuleName Slack {
    $functionName = (($PSCommandPath -split '\\')[-1]) -replace ".Tests.ps1",""
    $slackTestUri = "https://slack.com/api/api.test" 
    $ContentType = "application/json; charset=utf-8"
    #Slack External Select Element
    $placeholder = "Placeholder Text"
    $action_id = "externalselect1"
    $externalSelect = New-SlackExternalSelectMenuElement -placeholder $placeholder -action_id $action_id

    Describe "$functionName | Unit Tests" -Tags "Unit" {

        Context "Slack External Select Element | Unit Tests" {
            $properties = ("type", "placeholder", "action_id")
            $propertyCount = $properties.Count
    
            It "has a type of external_select" {
                $externalSelect.type | Should Be 'external_select'
            }
            It "has action_id `"$action_id`"" {
                $externalSelect.action_id | Should Be $action_id
            }
            It "has property count $propertyCount" {
                $externalSelect.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($externalSelect.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $externalSelect | ConvertTo-Json -Depth 100
            } 
        }

    }
}