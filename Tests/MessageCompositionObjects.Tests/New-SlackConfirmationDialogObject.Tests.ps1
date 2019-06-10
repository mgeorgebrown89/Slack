begin {
    # If the module is already in memory, remove it
    Get-Module PSlickPSlack | Remove-Module -Force

    # Import the module from the local path, not from the users Documents folder
    Import-Module .\PSlickPSlack\PSlickPSlack.psm1 -Force 
    $functionName = $MyInvocation.MyCommand -replace ".Tests.ps1", ""

    #Slack Comfirmation Dialog Object
    $title = "Confirmation Title"
    $text = "Confirmation Text"
    $confirm = "Yes"
    $deny = "No"
    $confirmationObject = New-SlackConfirmationDialogObject -title $title -text $text -confirmationText $confirm -denialText $deny
}
process {
    Describe "$functionName | Unit Tests" -Tags "Unit" {
        Context "Slack Confirmation Dialog Object | Unit Tests" {
    
            $properties = ("title", "text","confirm","deny")
            $propertyCount = $properties.Count
    
            It "An object is created" {
                [bool]$confirmationObject | Should -Be $true
            }
            It "has plain_text Text Object as title: `"$title`"" {
                $confirmationObject.title.type | Should -Be "plain_text"
                $confirmationObject.title.text | Should -Be $title
            }
            It "has Text Object as text: `"$title`"" {
                $confirmationObject.text.text | Should -Be $text
            }
            It "has plain_text Text Object as confirm: `"$confirm`"" {
                $confirmationObject.confirm.type | Should -Be "plain_text"
                $confirmationObject.confirm.text | Should -Be $confirm
            }
            It "has plain_text Text Object as deny: `"$deny`"" {
                $confirmationObject.deny.type | Should -Be "plain_text"
                $confirmationObject.deny.text | Should -Be $deny
            }
            It "has property count $propertyCount" {
                $confirmationObject.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($confirmationObject.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $confirmationObject | ConvertTo-Json -Depth 100
            }
        }
    }
}