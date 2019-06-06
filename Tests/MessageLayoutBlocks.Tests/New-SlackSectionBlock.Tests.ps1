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
        $slackContent = Get-Content .\slacktoken.json | ConvertFrom-Json
        $SlackUri = $slackContent.slackwebhook
        $SlackHeaders = @{Authorization = ("Bearer " + $slackContent.slacktoken) }
    }

    #section block
    $text = "This is a Slack Section Block with just text."
    $block = New-SlackSectionBlock -text $text

    #section block with text and block_id
    $text1 = "This is a Slack Section Block with text and a block_id."
    $block_id = "blockABC123"
    $blockWithTextAndBlockId = New-SlackSectionBlock -text $text1 -block_id $block_id

    #section block with text and fields
    $text2 = "This is a Slack Section Black with text and fields."
    $fields = @()
    $field1 = New-SlackTextObject -type mrkdwn -text "*Field 1 Title*`nField 1 Text"
    $fields += $field1
    $field2 = New-SlackTextObject -type plain_text -text "*Field 2 Title*`nField 2 Text"
    $fields += $field2
    $fieldCount = $fields.Count
    $blockWithTextAndFields = New-SlackSectionBlock -text $text2 -fields $fields

    #section block with text and an accessory
    $accessory = New-SlackButtonElement -text "ButtonText" -action_id "actionid_123"
    $text3 = "This is a Slack Section Black with text and an accessory."
    $blockWithTextAndAccessory = New-SlackSectionBlock -text $text3 -accessory $accessory
}
process {
    Describe "$functionName | Unit Tests" -Tags "Unit" {

        Context "Slack Section Block with text | Unit Tests" {
    
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
    
        Context "Slack Section Block with text and block_id | Unit Tests" {
            
            $properties = ("type", "text", "block_id")
            $propertyCount = $properties.Count
    
            It "has a type of section" {
                $blockWithTextAndBlockId.type | Should Be "section"
            }
            It "has text `"$text1`"" {
                $blockWithTextAndBlockId.text.text | Should Be $text1
            }
            It "has block_id `"$block_id`"" {
                $blockWithTextAndBlockId.block_id | Should Be $block_id
            }
            It "has property count $propertyCount" {
                $blockWithTextAndBlockId.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($blockWithTextAndBlockId.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $blockWithTextAndBlockId | ConvertTo-Json -Depth 100
            }
        }
    
        Context "Slack Section Block with text and fields | Unit Tests" {
    
            $properties = ("type", "text", "fields")
            $propertyCount = $properties.Count
    
            It "has a type of section" {
                $blockWithTextAndFields.type | Should Be "section"
            }
            It "has text `"$text2`"" {
                $blockWithTextAndFields.text.text | Should Be $text2
            }
            It "has property count $propertyCount" {
                $blockWithTextAndFields.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($blockWithTextAndFields.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "has field count $fieldCount" {
                $blockWithTextAndFields.fields | Should -HaveCount $fields.Length
            }
            It "is valid JSON" {
                $blockWithTextAndFields | ConvertTo-Json -Depth 100
            }
        }
    
        Context "Slack Section Block with text and accessory" {
    
            $properties = ("type", "text", "accessory")
            $propertyCount = $properties.Count
    
            It "has a type of section" {
                $blockWithTextAndFields.type | Should Be "section"
            }
            It "has text `"$text3`"" {
                $blockWithTextAndAccessory.text.text | Should Be $text3
            }
            It "has property count $propertyCount" {
                $blockWithTextAndAccessory.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($blockWithTextAndAccessory.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $blockWithTextAndAccessory | ConvertTo-Json -Depth 100
            }
        }
    }
    Describe "$functionName | Acceptance Tests" -Tags "Acceptance" {
    
        Context "Text only Slack Section Block | Acceptance Tests" {

            $blocks = @()
            $blocks += $block
            $Body = @{
                blocks = $blocks
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
    
        Context "Slack Section Block with text and block_id | Acceptance Tests" {
    
            $blocks = @()
            $blocks += $blockWithTextAndBlockId
            $Body = @{
                blocks = $blocks
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
    
        Context "Slack Section Block with text and fields | Acceptance Tests" {
    
            $blocks = @()
            $blocks += $blockWithTextAndFields
            $Body = @{
                blocks = $blocks
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
    
        Context "Slack Section Block with text and accessory | Acceptance Tests" {
            
            $blocks = @()
            $blocks += $blockWithTextAndAccessory
            $Body = @{
                blocks = $blocks
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
}