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

    #Slack plain_text Text Object
    $text = "Hello there. This is a plain_text Text Object for unit testing. :smile:"
    $plain_textTextObject = New-SlackTextObject -type plain_text -text $text

    #Slack plain_text no emoji Text Object
    $text1 = "Hello there. This is a plain_text Text Object with emoji set to false for unit testing. :smile:"
    $plain_textTextObjectNoEmoji = New-SlackTextObject -type plain_text -text $text1 -emoji $false

    #Slack mrkdwn Text Object
    $text2 = "*Hello* _there_. This is a mrkdwn Text Object for ~acceptance~ unit testing."
    $mrkdwnTextObject = New-SlackTextObject -type mrkdwn -text $text2

    #Slack mrkwn verbatim Text Object
    $text3 = "*Hello* _there_. This is a mrkdwn verbatim Text Object for ~unit~ acceptance testing. This is a link: https://github.com/mgeorgebrown89/Slack"
    $mrkdwnTextObjectVerbatim = New-SlackTextObject -type mrkdwn -text $text3 -verbatim $true
}
process {
    Describe "$functionName | Unit Tests" -Tags "Unit" {
        Context "plain_text Slack Text Object | Unit Tests" {
    
            $properties = ("type", "text", "emoji")
            $propertyCount = $properties.Count
    
            It "An object is created" {
                [bool]$plain_textTextObject | Should -Be $true
            }
            It "has a type of plain_text" {
                $plain_textTextObject.type | Should -BeExactly 'plain_text'
            }
            It "has text `"$text`"" {
                $plain_textTextObject.text | Should -Be $text
            }
            It "has property count $propertyCount" {
                $plain_textTextObject.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($plain_textTextObject.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $plain_textTextObject | ConvertTo-Json -Depth 100
            }
        }
        Context "plain_text with no emoji Slack Text Object | Unit Tests" {
    
            $properties = ("type", "text", "emoji")
            $propertyCount = $properties.Count
    
            It "An object is created" {
                [bool]$plain_textTextObjectNoEmoji | Should -Be $true
            }
            It "has a type of plain_text" {
                $plain_textTextObjectNoEmoji.type | Should -BeExactly 'plain_text'
            }
            It "has text `"$text1`"" {
                $plain_textTextObjectNoEmoji.text | Should -Be $text1
            }
            It "has property count $propertyCount" {
                $plain_textTextObjectNoEmoji.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($plain_textTextObjectNoEmoji.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $plain_textTextObjectNoEmoji | ConvertTo-Json -Depth 100
            }
            It "should have an emoji property set to false" {
                $plain_textTextObjectNoEmoji.emoji | Should Be $false
            }
        }
        Context "mrkdwn Slack Text Object | Unit Tests" {
    
            $properties = ("type", "text", "verbatim")
            $propertyCount = $properties.Count
    
            It "An object is created" {
                [bool]($mrkdwnTextObject) | Should -Be $true
            }
            It "has a type of plain_text" {
                $mrkdwnTextObject.type | Should -BeExactly 'mrkdwn'
            }
            It "has text `"$text2`"" {
                $mrkdwnTextObject.text | Should -Be $text2
            }
            It "has property count $propertyCount" {
                $mrkdwnTextObject.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($mrkdwnTextObject.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $mrkdwnTextObject | ConvertTo-Json -Depth 100
            }
        }
        Context "mrkdwn verbatim Slack Text Object | Unit Tests" {
    
            $properties = ("type", "text", "verbatim")
            $propertyCount = $properties.Count
    
            It "An object is created" {
                [bool]($mrkdwnTextObjectVerbatim) | Should -Be $true
            }
            It "has a type of plain_text" {
                $mrkdwnTextObjectVerbatim.type | Should -BeExactly 'mrkdwn'
            }
            It "has text `"$text3`"" {
                $mrkdwnTextObjectVerbatim.text | Should -Be $text3
            }
            It "has property count $propertyCount" {
                $mrkdwnTextObjectVerbatim.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($mrkdwnTextObjectVerbatim.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $mrkdwnTextObjectVerbatim | ConvertTo-Json -Depth 100
            }
        }
    }
    Describe "$functionName | Acceptance Tests" -Tags "Acceptance" {
        Context "plain_text Slack Text Object | Acceptance Tests" {
    
            $Body = @{
                text = $plain_textTextObject 
            }
    
            It "returns http 200 response" {
                $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100)
                $response.ok | Should Be "true"
                $response.warning | Should Be $null
            }
        }

        Context "plain_text with no emoji Slack Text Object | Acceptance Tests" {

            $Body = @{
                text = $plain_textTextObjectNoEmoji
            }
    
            It "returns http 200 response" {
                $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100)
                $response.ok | Should Be "true"
                $response.warning | Should Be $null
            }
        }
    
        Context "mrkdwn Slack Text Object | Acceptance Tests" {
    
            $Body = @{
                text = $mrkdwnTextObject 
            }
    
            It "returns http 200 response" {
                $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100) -SkipHeaderValidation
                $response.ok | Should Be "true"
                $response.warning | Should Be $null
            }
        }

        Context "mrkdwn verbatim Slack Text Object | Acceptance Tests" {
    
            $Body = @{
                text = $mrkdwnTextObjectVerbatim
            }
    
            It "returns http 200 response" {
                $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100) -SkipHeaderValidation
                $response.ok | Should Be "true"
                $response.warning | Should Be $null
            }
        }
    }
}