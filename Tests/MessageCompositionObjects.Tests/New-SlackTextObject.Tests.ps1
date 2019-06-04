# If the module is already in memory, remove it
Get-Module PSlickPSlack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
Import-Module .\PSlickPSlack\PSlickPSlack.psm1
$functionName = $MyInvocation.MyCommand -replace ".Tests.ps1", ""

Describe "$functionName plain_text Test Object Tests" {
    
    $text = "Hello there."
    $plain_textObject = New-SlackTextObject -type plain_text -text $text
    $properties = ("type", "text", "emoji")
    $propertyCount = $properties.Count

    Describe "Slack plain_text Object unit tests" -Tags "Unit" {
        It "An object is created" {
            [bool](New-SlackTextObject -type "plain_text" -text $text) | Should -Be $true
        }
        It "has a type of plain_text" {
            $plain_textObject.type | Should -BeExactly 'plain_text'
        }
        It "has text `"$text`"" {
            $plain_textObject.text | Should -Be $text
        }
        It "has property count $propertyCount" {
            $plain_textObject.PSObject.Properties.Name | Should -HaveCount $properties.Count
        }
        foreach ($property in $properties) {
            It "has a $property property" {
                [bool]($plain_textObject.PSObject.Properties.Name -match $property) | Should Be $true
            }
        }
        It "is valid JSON" {
            $plain_textObject | ConvertTo-Json -Depth 100
        }
    }
    Describe "Slack plain_text Object Acceptance tests" -Tags "Acceptance" {
        $slackContent = Get-Content .\slacktoken.json | ConvertFrom-Json
        $Body = $plain_textObject | ConvertTo-Json -Depth 100
        It "returns http 200 response" {
            $params = @{
                Method      = "Post"
                Uri         = $slackContent.slackwebhook
                Headers     = @{Authorization = ("Bearer " + $slackContent.slacktoken) }
                ContentType = "application/json"
                Body        = $Body
            }
            Invoke-RestMethod @params | Should Be "ok"
        }
    }
}
Describe "$functionName mrdkwn Test Object Tests" {
    $text = "*Hello* _there_."
    $mrkdwnObject = New-SlackTextObject -type mrkdwn -text $text
    $properties = ("type", "text", "verbatim")
    $propertyCount = $properties.Count
    
    Describe "Slack mrkdwn Object unit tests" -Tags "Unit" {
        It "An object is created" {
            [bool](New-SlackTextObject -type "plain_text" -text $text) | Should -Be $true
        }
        It "has a type of plain_text" {
            $mrkdwnObject.type | Should -BeExactly 'mrkdwn'
        }
        It "has text `"$text`"" {
            $mrkdwnObject.text | Should -Be $text
        }
        It "has property count $propertyCount" {
            $mrkdwnObject.PSObject.Properties.Name | Should -HaveCount $properties.Count
        }
        foreach ($property in $properties) {
            It "has a $property property" {
                [bool]($mrkdwnObject.PSObject.Properties.Name -match $property) | Should Be $true
            }
        }
        It "is valid JSON" {
            $mrkdwnObject | ConvertTo-Json -Depth 100
        }
    }
    Describe "Slack mrkdwn Object Acceptance tests" -Tags "Acceptance" {
        $slackContent = Get-Content .\slacktoken.json | ConvertFrom-Json
        $Body = $mrkdwnObject | ConvertTo-Json -Depth 100
        It "returns http 200 response" {
            $params = @{
                Method      = "Post"
                Uri         = $slackContent.slackwebhook
                Headers     = @{Authorization = ("Bearer " + $slackContent.slacktoken) }
                ContentType = "application/json"
                Body        = $Body
            }
            Invoke-RestMethod @params | Should Be "ok"
        }
    }
}