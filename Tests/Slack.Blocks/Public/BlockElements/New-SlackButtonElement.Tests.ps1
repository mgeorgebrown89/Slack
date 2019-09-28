# If the module is already in memory, remove it
Get-Module Slack | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent ((Split-Path -Parent $MyInvocation.MyCommand.Path)))))
$ModuleRoot = $repoRoot + "\Slack"
Import-Module $ModuleRoot -Force 

$slackContent = Get-Content $ModuleRoot\SlackDefaults.json | ConvertFrom-Json
$SlackUri = $slackContent.slackwebhook
$SlackHeaders = @{Authorization = ("Bearer " + $slackContent.slacktoken) }

InModuleScope -ModuleName Slack {
    $functionName = (($PSCommandPath -split '\\')[-1]) -replace ".Tests.ps1",""
    $slackTestUri = "https://slack.com/api/api.test" 
    $ContentType = "application/json; charset=utf-8"
    #Slack Button Element
    $text = "Button"
    $action_id = "Button0"
    $SlackButtonElement = New-SlackButtonElement -text $text -action_id $action_id

    #Slack Button Element with url
    $text1 = "Button w/ url"
    $action_id1 = "Button1"
    $url = "https://github.com/mgeorgebrown89/Slack"
    $SlackButtonElementWithUrl = New-SlackButtonElement -text $text1 -action_id $action_id1 -url $url

    #Slack Button Element with value
    $text2 = "Button w/ value"
    $action_id2 = "Button2"
    $value = "TheButtonsValue"
    $SlackButtonElementWithValue = New-SlackButtonElement -text $text2 -action_id $action_id2 -value $value

    #Slack Button Element with style
    $styledButtons = @()
    $text3 = "PrimaryButton"
    $action_id3 = "Button3"
    $style1 = "primary"
    $styledButtons += New-SlackButtonElement -text $text3 -action_id $action_id3 -style $style1
    $text4 = "DangerButton"
    $action_id4 = "Button4"
    $style2 = "danger"
    $styledButtons += New-SlackButtonElement -text $text4 -action_id $action_id4 -style $style2

    #Slack Button Element with confirmation
    $confirm = New-SlackConfirmationDialogObject -title "Confirmation Title" -text "Confirmation Text" -confirmationText "Confirmation Confirmation" -denialText "Confirmation Denial"
    $text5 = "Button w/ Confirm"
    $action_id5 = "Button5"
    $SlackButtonWithConfirm = New-SlackButtonElement -text $text5 -action_id $action_id5 -confirm $confirm

    Describe "$functionName | Unit Tests" -Tags "Unit" {

        Context "Slack Button Element | Unit Tests" {

            $properties = ("type", "text", "action_id")
            $propertyCount = $properties.Count
    
            It "has a type of button" {
                $SlackButtonElement.type | Should Be 'button'
            }
            It "has text `"$text`"" {
                $SlackButtonElement.text.text | Should Be $text
                $SlackButtonElement.text.type | Should -BeIn @("plain_text", "mrkdwn")
            }
            It "has action_id `"$action_id`"" {
                $SlackButtonElement.action_id | Should Be $action_id
            }
            It "has property count $propertyCount" {
                $SlackButtonElement.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($SlackButtonElement.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $SlackButtonElement | ConvertTo-Json -Depth 100
            } 
        }
        Context "Slack Button Element with url | Unit Tests" {

            $properties = ("type", "text", "action_id", "url")
            $propertyCount = $properties.Count
    
            It "has a type of button" {
                $SlackButtonElementWithUrl.type | Should Be 'button'
            }
            It "has text `"$text1`"" {
                $SlackButtonElementWithUrl.text.text | Should Be $text1
                $SlackButtonElementWithUrl.text.type | Should -BeIn @("plain_text", "mrkdwn")
            }
            It "has action_id `"$action_id1`"" {
                $SlackButtonElementWithUrl.action_id | Should Be $action_id1
            }
            It "has url `"$url`"" {
                $SlackButtonElementWithUrl.url | Should Be $url
            }
            It "has property count $propertyCount" {
                $SlackButtonElementWithUrl.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($SlackButtonElementWithUrl.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $SlackButtonElementWithUrl | ConvertTo-Json -Depth 100
            } 
        }
        Context "Slack Button Element with value | Unit Tests" {

            $properties = ("type", "text", "action_id", "value")
            $propertyCount = $properties.Count
    
            It "has a type of button" {
                $SlackButtonElementWithValue.type | Should Be 'button'
            }
            It "has text `"$text2`"" {
                $SlackButtonElementWithValue.text.text | Should Be $text2
                $SlackButtonElementWithValue.text.type | Should -BeIn @("plain_text", "mrkdwn")
            }
            It "has action_id `"$action_id2`"" {
                $SlackButtonElementWithValue.action_id | Should Be $action_id2
            }
            It "has value `"$value`"" {
                $SlackButtonElementWithValue.value | Should Be $value
            }
            It "has property count $propertyCount" {
                $SlackButtonElementWithValue.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($SlackButtonElementWithValue.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $SlackButtonElementWithValue | ConvertTo-Json -Depth 100
            } 
        }
        Context "Slack Button Element with style | Unit Tests" {

            $properties = ("type", "text", "action_id", "style")
            $propertyCount = $properties.Count
    
            foreach ($button in $styledButtons) {
                It "has a type of button" {
                    $button.type | Should Be 'button'
                }
                It "has correct text" {
                    $button.text.text | Should -BeIn @($text3, $text4)
                    $button.text.type | Should -BeIn @("plain_text", "mrkdwn")
                }
                It "has correct action_id" {
                    $button.action_id | Should -BeIn @($action_id3, $action_id4)
                }
                It "has correct style" {
                    $button.style | Should -BeIn @($style1, $style2)
                }
                It "has property count $propertyCount" {
                    $button.PSObject.Properties.Name | Should -HaveCount $properties.Count
                }
                foreach ($property in $properties) {
                    It "has a $property property" {
                        [bool]($button.PSObject.Properties.Name -match $property) | Should Be $true
                    }
                }
                It "is valid JSON" {
                    $button | ConvertTo-Json -Depth 100
                } 
            }
        }
        Context "Slack Button Element with confirmation | Unit Tests" {

            $properties = ("type", "text", "action_id", "confirm")
            $propertyCount = $properties.Count
    
            It "has a type of button" {
                $SlackButtonWithConfirm.type | Should Be 'button'
            }
            It "has text `"$text5`"" {
                $SlackButtonWithConfirm.text.text | Should Be $text5
                $SlackButtonWithConfirm.text.type | Should -BeIn @("plain_text", "mrkdwn")
            }
            It "has action_id `"$action_id5`"" {
                $SlackButtonWithConfirm.action_id | Should Be $action_id5
            }
            It "has property count $propertyCount" {
                $SlackButtonWithConfirm.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($SlackButtonWithConfirm.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $SlackButtonWithConfirm | ConvertTo-Json -Depth 100
            } 
        }
    }
}