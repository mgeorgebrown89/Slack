begin {
    # If the module is already in memory, remove it
    Get-Module Slack | Remove-Module -Force

    # Import the module from the local path, not from the users Documents folder
    Import-Module .\Slack\Slack.psm1 -Force 
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

    #divider block
    $divider = New-SlackDividerBlock

    #divider with block_id
    $block_id = "dividerblock123"
    $dividerWithBlockId = New-SlackDividerBlock -block_id $block_id
}
process {
    Describe "$functionName | Unit Tests" -Tags "Unit" {

        Context "Slack Divider Block | Unit Tests" {
    
            $properties = @("type")
            $propertyCount = $properties.Count
    
            It "has a type of divider" {
                $divider.type | Should Be 'divider'
            }
            It "has property count $propertyCount" {
                $divider.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($divider.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $divider | ConvertTo-Json -Depth 100
            }
        }
    
        Context "Slack Divider Block with block_id | Unit Tests" {
    
            $properties = @("type", "block_id")
            $propertyCount = $properties.Count
    
            It "has a type of divider" {
                $dividerWithBlockId.type | Should Be 'divider'
            }
            It "has a block_id of $block_id" {
                $dividerWithBlockId.block_id | Should Be $block_id
            }
            It "has property count $propertyCount" {
                $dividerWithBlockId.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($dividerWithBlockId.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $dividerWithBlockId | ConvertTo-Json -Depth 100
            }
        }
    }
    
    Describe "$functionName | Acceptance Tests" -Tags "Acceptance" {
    
        Context "Slack Divider Block | Acceptance Tests" {
    
            $Blocks = @()
            $Blocks += $divider
            $Body = @{
                blocks = $Blocks
            }
    
            It "returns http 200 response" {
                $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100) -SkipHeaderValidation
                $response.ok | Should Be "true"
                $response.warning | Should Be $null
            }
        }
    
        Context "Slack Divider Block with block_id | Acceptance Tests" {
    
            $Blocks = @()
            $Blocks += $dividerWithBlockId
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