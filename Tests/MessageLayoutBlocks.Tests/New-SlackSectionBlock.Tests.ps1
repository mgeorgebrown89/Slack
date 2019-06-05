# If the module is already in memory, remove it
Get-Module PSlickPSlack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
Import-Module .\PSlickPSlack\PSlickPSlack.psm1 -Force 
$functionName = $MyInvocation.MyCommand -replace ".Tests.ps1",""

if ($env:APPVEYOR) {
    $SlackUri = $env:slackwebhook
    $SlackHeaders = @{Authorization = ("Bearer " + $ev:slacktoken) }
}
else {
    $slackContent = Get-Content .\slacktoken.json | ConvertFrom-Json
    $SlackUri = $slackContent.slackwebhook
    $SlackHeaders = @{Authorization = ("Bearer " + $slackContent.slacktoken) }
}

Describe "$functionName | Unit Tests" -Tags "Unit" {
    Context "Text Only Slack Section Block | Unit Tests" {

        $text = "This is a Slack Section Block with just text."
        $block = New-SlackSectionBlock -text $text
        $properties = ("type", "text")
        $propertyCount = $properties.Count

        It "has a type of section" {
            $block.type | Should Be 'section'
        }
        It "has text `"$text`"" {
            $block.text.text | Should Be $text
        }
        It "has property count $propertyCount" {
            $block.PSObject.Properties.Name | Should -HaveCount $properties.Count
        }
        foreach ($property in $properties) {
            It "has a $property property" {
                [bool]($block.PSObject.Properties.Name -match $property) | Should Be $true
            }
        }
        It "is valid JSON" {
            $block | ConvertTo-Json -Depth 100
        }
    }
    Context "Text with block_id Slack Section Block" {
        
        $text = "This is a Slack Section Block with text and a block_id."
        $block_id = "blockABC123"
        $block = New-SlackSectionBlock -text $text -block_id $block_id
        $properties = ("type", "text", "block_id")
        $propertyCount = $properties.Count

        It "has a type of section" {
            $block.type | Should Be "section"
        }
        It "has text `"$text`"" {
            $block.text.text | Should Be $text
        }
        It "has block_id `"$block_id`"" {
            $block.block_id | Should Be $block_id
        }
        It "has property count $propertyCount" {
            $block.PSObject.Properties.Name | Should -HaveCount $properties.Count
        }
        foreach ($property in $properties) {
            It "has a $property property" {
                [bool]($block.PSObject.Properties.Name -match $property) | Should Be $true
            }
        }
        It "is valid JSON" {
            $block | ConvertTo-Json -Depth 100
        }
    }
}
Describe "$functionName | Acceptance Tests" -Tags "Acceptance" {
    Context "Text only Slack Section Block | Acceptance Tests" {

        $text = "This is a Slack Section Block with just text."
        $block = @()
        $block += New-SlackSectionBlock -text $text
        $Body = @{
            blocks = $block
        }
        $params = @{
            Method      = "Post"
            Uri         = $SlackUri
            Headers     = $SlackHeaders
            ContentType = "application/json"
            Body        = $Body | ConvertTo-Json -Depth 100
        }

        It "returns http 200 response" {
            $response = Invoke-RestMethod @params 
            $response | Should Be "ok"
        }
    }
}


Describe "New-SlackSectionBlock Integration Tests" -Tags "Integration" {
    $text = "Lorum au latin words and other stuffs."
    Context "Text with Fields Slack Section Block" {
        $fields = @()
        $field1 = New-SlackTextObject -type mrkdwn -text $text
        $fields += $field1
        $field2 = New-SlackTextObject -type plain_text -text $text
        $fields += $field2
        $fieldCount = $fields.Count
        $block = New-SlackSectionBlock -text $text -fields $fields
        $properties = ("type", "text", "fields")
        $propertyCount = $properties.Count
        It "has a type of section" {
            $block.type | Should Be "section"
        }
        It "has text `"$text`"" {
            $block.text.text | Should Be $text
        }
        It "has property count $propertyCount" {
            $block.PSObject.Properties.Name | Should -HaveCount $properties.Count
        }
        foreach ($property in $properties) {
            It "has a $property property" {
                [bool]($block.PSObject.Properties.Name -match $property) | Should Be $true
            }
        }
        It "has field count $fieldCount" {
            $block.fields | Should -HaveCount $fields.Length
        }
        It "is valid JSON" {
            $block | ConvertTo-Json -Depth 100
        }
    }
    Context "Text with accessory Slack Section Block" {
        $accessory = New-SlackButtonElement -text "ButtonText" -action_id "ButtonAction_id"
        $block = New-SlackSectionBlock -text $text -accessory $accessory
        $properties = ("type", "text", "accessory")
        $propertyCount = $properties.Count
        It "has a type of section" {
            $block.type | Should Be "section"
        }
        It "has text `"$text`"" {
            $block.text.text | Should Be $text
        }
        It "has property count $propertyCount" {
            $block.PSObject.Properties.Name | Should -HaveCount $properties.Count
        }
        foreach ($property in $properties) {
            It "has a $property property" {
                [bool]($block.PSObject.Properties.Name -match $property) | Should Be $true
            }
        }
        It "is valid JSON" {
            $block | ConvertTo-Json -Depth 100
        }
    }
}