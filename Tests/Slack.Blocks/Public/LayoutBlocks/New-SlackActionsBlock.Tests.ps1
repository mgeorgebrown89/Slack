# If the module is already in memory, remove it
Get-Module Slack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
Import-Module $Global:SlackModulePath -Force 
$functionName = $MyInvocation.MyCommand -replace ".Tests.ps1", ""

if ($env:APPVEYOR) {
    $SlackUri = $env:slackwebhook
    $SlackHeaders = @{Authorization = ("Bearer " + $ev:slacktoken) }
}
else {
    $root = Split-Path -Parent (Split-Path -Parent ((Split-Path -Parent $MyInvocation.MyCommand.Path)))
    $slackContent = Get-Content $root\Slack\SlackDefaults.json | ConvertFrom-Json
    $SlackUri = $slackContent.slackwebhook
    $SlackHeaders = @{Authorization = ("Bearer " + $slackContent.slacktoken) }
}
$slackTestUri = "https://slack.com/api/api.test" 
$ContentType = "application/json; charset=utf-8"

InModuleScope -ModuleName Slack {
    #slack Actions Block
    $elements = @()
    $elements += New-SlackButtonElement -text "ActionBlock" -action_id "Button1" -value "One"
    $elements += New-SlackButtonElement -text "Slack" -action_id "Button2" -url "https://github.com/mgeorgebrown89/Slack"
    $actionsBlock = New-SlackActionsBlock -elements $elements
    
    #slack Actions Block with block_id
    $elements = @()
    $elements += New-SlackButtonElement -text "ActionBlockWithBlockId" -action_id "Button3" -value "Two"
    $elements += New-SlackButtonElement -text "Slack" -action_id "Button4" -url "https://github.com/mgeorgebrown89/Slack"
    $block_id = "actionBlock123"
    $actionsBlockWithBlockId = New-SlackActionsBlock -elements $elements -block_id $block_id

    Describe "$functionName | Unit Tests" -Tags "Unit" {

        Context "Slack Actions Block | Unit Tests" { 

            $properties = ("type", "elements")
            $propertyCount = $properties.Count
    
            It "has a type of actions" {
                $actionsBlock.type | Should Be 'actions'
            }
            It "has property count $propertyCount" {
                $actionsBlock.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($actionsBlock.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $actionsBlock | ConvertTo-Json -Depth 100
            }
        }

        Context "Slack Actions Block with block_id | Unit Tests" {

            $properties = ("type", "elements", "block_id")
            $propertyCount = $properties.Count
    
            It "has a type of actions" {
                $actionsBlockWithBlockId.type | Should Be 'actions'
            }
            It "has block_id `"$block_id`"" {
                $actionsBlockWithBlockId.block_id | Should Be $block_id
            }
            It "has property count $propertyCount" {
                $actionsBlockWithBlockId.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($actionsBlockWithBlockId.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $actionsBlockWithBlockId | ConvertTo-Json -Depth 100
            }
        } 
    }

    Describe "$functionName | Acceptance Tests" -Tags "Acceptance" {

        Context "Slack Actions Block | Acceptance Tests" { 

            $Blocks = @()
            $Blocks += $actionsBlock
            $Body = @{
                blocks = $Blocks
            }
    
            It "returns http 200 response" {
                $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100)
                $response.ok | Should Be "true"
                $response.warning | Should Be $null
            }
        }

        Context "Slack Actions Block with block_id | Acceptance Tests" {
            
            $Blocks = @()
            $Blocks += $actionsBlockWithBlockId
            $Body = @{
                blocks = $Blocks
            }
    
            It "returns http 200 response" {
                $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100)
                $response.warning | Should Be $null
            }
        } 
    }
}