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
    #slack context block
    $elements = @()
    $elements += New-SlackImageElement -image_url "https://raw.githubusercontent.com/mgeorgebrown89/Slack/master/Media/Slack_Module_icon.png" -alt_text "Slack Icon"
    $elements += New-SlackTextObject -type mrkdwn -text "*This* _is_ a context block."
    $contextBlock = New-SlackContextBlock -elements $elements

    #slack context block with block_id
    $elements = @()
    $elements += New-SlackImageElement -image_url "https://raw.githubusercontent.com/mgeorgebrown89/Slack/master/Media/Slack_Module_icon.png" -alt_text "Slack Icon"
    $elements += New-SlackTextObject -type mrkdwn -text "*This* _is_ a context block with a block_id"
    $block_id = "contextblock123"
    $contextBlockWithBlockId = New-SlackContextBlock -elements $elements -block_id $block_id

    Describe "$functionName | Unit Tests" -Tags "Unit" {

        Context "Slack Context Block | Unit Tests" { 

            $properties = ("type", "elements")
            $propertyCount = $properties.Count
    
            It "has a type of context" {
                $contextBlock.type | Should Be 'context'
            }
            It "has property count $propertyCount" {
                $contextBlock.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($contextBlock.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $contextBlock | ConvertTo-Json -Depth 100
            }
        }

        Context "Slack Context Block with a block_id | Unit Tests" { 

            $properties = ("type", "elements", "block_id")
            $propertyCount = $properties.Count
    
            It "has a type of context" {
                $contextBlockWithBlockId.type | Should Be 'context'
            }
            It "has block_id `"$block_id`"" {
                $contextBlockWithBlockId.block_id | Should Be $block_id
            }
            It "has property count $propertyCount" {
                $contextBlockWithBlockId.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($contextBlockWithBlockId.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $contextBlockWithBlockId | ConvertTo-Json -Depth 100
            }
        }
    }

    Describe "$functionName | Acceptance Tests" -Tags "Acceptance" {

        Context "Slack Context Block | Acceptance Tests" {

            $Blocks = @()
            $Blocks += $contextBlock
            $Body = @{
                blocks = $Blocks
            }
    
            It "returns http 200 response" {
                $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100) -SkipHeaderValidation
                $response.ok | Should Be "true"
                $response.warning | Should Be $null
            }
        }

        Context "Slack Context Block | Acceptance Tests" {

            $Blocks = @()
            $Blocks += $contextBlockWithBlockId
            $Body = @{
                blocks = $Blocks
            }
    
            It "returns http 200 response" {
                $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100) -SkipHeaderValidation
                $response.ok | Should Be "true"
                $response.warning | Should Be $null
            }
        }
    }
}