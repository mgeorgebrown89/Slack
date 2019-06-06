# If the module is already in memory, remove it
Get-Module PSlickPSlack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
Import-Module .\PSlickPSlack\PSlickPSlack.psm1
$functionName = $MyInvocation.MyCommand -replace ".Tests.ps1", ""

if ($env:APPVEYOR) {
    $SlackUri = $env:slackwebhook
    $SlackHeaders = @{Authorization = ("Bearer " + $ev:slacktoken) }
}
else {
    $slackContent = Get-Content .\slacktoken.json | ConvertFrom-Json
    $SlackUri = $slackContent.slackwebhook
    $SlackHeaders = @{Authorization = ("Bearer " + $slackContent.slacktoken) }
}
$slackTestUri = "https://slack.com/api/api.test" 
$ContentType = "application/json; charset=utf-8"

Describe "$functionName | Unit Tests" -Tags "Unit" {
    Context "plain_text Slack Text Object | Unit Tests" {

        $text = "Hello there. This is a plain_text Text Object for unit testing. :smile:"
        $plain_textTextObject = New-SlackTextObject -type plain_text -text $text
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

        $text = "Hello there. This is a plain_text Text Object with emoji set to false for unit testing. :smile:"
        $plain_textTextObject = New-SlackTextObject -type plain_text -text $text -emoji $false
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
        It "should have an emoji property set to false" {
            $plain_textTextObject.emoji | Should Be $false
        }
    }
    Context "mrkdwn Slack Text Object | Unit Tests" {

        $text = "*Hello* _there_. This is a mrkdwn Text Object for ~acceptance~ unit testing."
        $mrkdwnTextObject = New-SlackTextObject -type mrkdwn -text $text
        $properties = ("type", "text", "verbatim")
        $propertyCount = $properties.Count

        It "An object is created" {
            [bool](New-SlackTextObject -type "plain_text" -text $text) | Should -Be $true
        }
        It "has a type of plain_text" {
            $mrkdwnTextObject.type | Should -BeExactly 'mrkdwn'
        }
        It "has text `"$text`"" {
            $mrkdwnTextObject.text | Should -Be $text
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

}
Describe "$functionName | Acceptance Tests" -Tags "Acceptance" {
    Context "plain_text Slack Text Object | Acceptance Tests" {

        $text = "Hello there. This is a plain_text Text Object for acceptance testing. :smile:"
        $plain_textTextObject = New-SlackTextObject -type plain_text -text $text
        $Body = @{
            text = $plain_textTextObject 
        }

        It "returns http 200 response" {
            $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100)
            $response.ok | Should Be "true"
            $response.warning | Should Be $null
        }
    }
    #This test doesn't seem to work correctly. The text object might need to be part of a Block for this to work properly. 
    Context "plain_text with no emoji Slack Text Object | Acceptance Tests" {
        $text = "Hello there. This is a plain_text with no emoji Text Object for acceptance testing. :smile:"
        $plain_textTextObject = New-SlackTextObject -type plain_text -text $text -emoji $false
        $Body = @{
            text = $plain_textTextObject 
        }

        It "returns http 200 response" {
            $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100)
            $response.ok | Should Be "true"
            $response.warning | Should Be $null
        }
    }

    Context "mrkdwn Slack Text Object | Acceptance Tests" {

        $text = "*Hello* _there_. This is a mrkdwn Text Object for ~unit~ acceptance testing. This is a link: https://github.com/mgeorgebrown89/PSlickPSlack"
        $mrkdwnTextObject = New-SlackTextObject -type mrkdwn -text $text
        $Body = @{
            text = $mrkdwnTextObject 
        }

        It "returns http 200 response" {
            $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100)
            $response.ok | Should Be "true"
            $response.warning | Should Be $null
        }
    }
    #This one doesn't really work either. 
    Context "mrkdwn verbatim Slack Text Object | Acceptance Tests" {

        $text = "*Hello* _there_. This is a mrkdwn verbatim Text Object for ~unit~ acceptance testing. This is a link: https://github.com/mgeorgebrown89/PSlickPSlack"
        $mrkdwnTextObject = New-SlackTextObject -type mrkdwn -text $text -verbatim $true
        $Body = @{
            text = $mrkdwnTextObject 
        }

        It "returns http 200 response" {
            $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100)
            $response.ok | Should Be "true"
            $response.warning | Should Be $null
        }
    }
}