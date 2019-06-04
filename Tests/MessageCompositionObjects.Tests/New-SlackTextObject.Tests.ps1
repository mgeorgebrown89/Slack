# If the module is already in memory, remove it
Get-Module PSlickPSlack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
Import-Module .\PSlickPSlack\PSlickPSlack.psm1
$functionName = $MyInvocation.MyCommand -replace ".Tests.ps1", ""

Describe "$functionName Unit Tests" -Tags "Unit" {
    Context "plain_text Text Object Unit Tests" {

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
    Context "plain_text with no emoji Text Object Unit Tests" {

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
    Context "mrkdwn Text Object Unit Tests" {

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
Describe "$functionName Text Object Acceptance Tests" -Tags "Acceptance" {
    Context "plain_text Text Object Acceptance Tests" {

        $text = "Hello there. This is a plain_text Text Object for acceptance testing."
        $plain_textTextObject = New-SlackTextObject -type plain_text -text $text
        $Body = $plain_textTextObject | ConvertTo-Json -Depth 100

        if ($env:APPVEYOR) {
            $params = @{
                Method      = "Post"
                Uri         = $env:slackwebhook
                Headers     = @{Authorization = ("Bearer " + $env:slacktoken) }
                ContentType = "application/json"
                Body        = $Body
            }
        }
        else {
            $slackContent = Get-Content .\slacktoken.json | ConvertFrom-Json
            $params = @{
                Method      = "Post"
                Uri         = $slackContent.slackwebhook
                Headers     = @{Authorization = ("Bearer " + $slackContent.slacktoken) }
                ContentType = "application/json"
                Body        = $Body
            }
        }

        It "returns http 200 response" {
            Invoke-RestMethod @params | Should Be "ok"
        }
    }
    Context "mrkdwn Text Object Acceptance Tests" {

        $text = "*Hello* _there_. This is a mrkdwn Text Object for ~unit~ acceptance testing."
        $mrkdwnTextObject = New-SlackTextObject -type mrkdwn -text $text
        $Body = $mrkdwnTextObject | ConvertTo-Json -Depth 100

        if ($env:APPVEYOR) {
            $params = @{
                Method      = "Post"
                Uri         = $env:slackwebhook
                Headers     = @{Authorization = ("Bearer " + $env:slacktoken) }
                ContentType = "application/json"
                Body        = $Body
            }
        }
        else {
            $slackContent = Get-Content .\slacktoken.json | ConvertFrom-Json
            $params = @{
                Method      = "Post"
                Uri         = $slackContent.slackwebhook
                Headers     = @{Authorization = ("Bearer " + $slackContent.slacktoken) }
                ContentType = "application/json"
                Body        = $Body
            }
        }
        It "returns http 200 response" {
            Invoke-RestMethod @params | Should Be "ok"
        }
    }
}