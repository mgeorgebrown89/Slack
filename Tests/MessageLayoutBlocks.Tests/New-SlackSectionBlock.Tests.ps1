# If the module is already in memory, remove it
Get-Module PSlickPSlack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
Import-Module .\PSlickPSlack\PSlickPSlack.psm1 -Force 

Describe "New-SlackSectionBlock Unit Tests" -Tags "Unit" {
    $text = "Lorum au latin words and stuff."
    Context "Text Only Slack Section Block" {
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