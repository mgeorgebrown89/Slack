# Get the path the script is executing from
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here
# If the module is already in memory, remove it
Get-Module PSlickPSlack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
Import-Module .\PSlickPSlack\PSlickPSlack.psm1 -Force 

Describe "New-SlackDividerBlock Unit Tests" -Tags "Unit" {
    Context "Slack Divider Block" {
        $divider = New-SlackDividerBlock
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
    Context "Slack Divider Block with block_id" {
        $block_id = "blockABC123"
        $divider = New-SlackDividerBlock -block_id $block_id
        $properties = @("type","block_id")
        $propertyCount = $properties.Count

        It "has a type of divider" {
            $divider.type | Should Be 'divider'
        }
        It "has a block_id of $block_id" {
            $divider.block_id | Should Be $block_id
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
}