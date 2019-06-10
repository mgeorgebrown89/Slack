begin {
    # If the module is already in memory, remove it
    Get-Module PSlickPSlack | Remove-Module -Force

    # Import the module from the local path, not from the users Documents folder
    Import-Module .\PSlickPSlack\PSlickPSlack.psm1 -Force 
    $functionName = $MyInvocation.MyCommand -replace ".Tests.ps1", ""

    if ($env:APPVEYOR) {
        $SlackUri = $env:slackwebhook
        $SlackHeaders = @{Authorization = ("Bearer " + $ev:slacktoken) }
    }
    else {
        $root = Split-Path -Parent (Split-Path -Parent ((Split-Path -Parent $MyInvocation.MyCommand.Path)))
        $slackContent = Get-Content $root\slacktoken.json | ConvertFrom-Json
        $SlackUri = $slackContent.slackwebhook
        $SlackHeaders = @{Authorization = ("Bearer " + $slackContent.slacktoken) }
    }
    $slackTestUri = "https://slack.com/api/api.test" 
    $ContentType = "application/json; charset=utf-8"

    #Slack Option Group
    $options = @()
    $label = "Slack Option Group"
    $optionGroup = New-SlackOptionGroupObject -label $label -SlackOptions $options
}
process {
    Describe "$functionName | Unit Tests" -Tags "Unit" {
        Context "Slack Option Group Object | Unit Tests" {
    
            $properties = ("label", "options")
            $propertyCount = $properties.Count
    
            It "An object is created" {
                [bool]$optionGroup | Should -Be $true
            }
            It "has plain_text Text Object as label: `"$label`"" {
                $optionGroup.label.type | Should -Be "plain_text"
                $optionGroup.label.text | Should -Be $label
            }
            It "has property count $propertyCount" {
                $optionGroup.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($optionGroup.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $optionGroup | ConvertTo-Json -Depth 100
            }
        }
    }
}