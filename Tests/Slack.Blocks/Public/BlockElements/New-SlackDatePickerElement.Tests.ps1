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
    #Slack Date Picker Element
    $action_id = "datepicker1"
    $datepicker = New-SlackDatePickerElement -action_id $action_id

    #Slack Date Picker Element with placeholder
    $action_id1 = "datepicker2"
    $placeholder = "Select a Date"
    $datepickerWithPlaceholder = New-SlackDatePickerElement -action_id $action_id1 -placeholder $placeholder

    #Slack Date Picker Element with initial_date
    $action_id2 = "datepicker3"
    $initialDate = "2019-06-01"
    $datepickerWithInitialDate = New-SlackDatePickerElement -action_id $action_id2 -initial_date $initialDate

    #Slack Date Picker Element with confirm
    $action_id3 = "datepicker4"
    $confirm = New-SlackConfirmationDialogObject -title "title" -text "text" -confirmationText "Yes" -denialText "No"
    $datepickerWithConfirm = New-SlackDatePickerElement -action_id $action_id3 -confirm $confirm

    Describe "$functionName | Unit Tests" -Tags "Unit" {

        Context "Slack Date Picker Element | Unit Tests" {

            $properties = ("type", "action_id")
            $propertyCount = $properties.Count
    
            It "has a type of datepicker" {
                $datepicker.type | Should Be 'datepicker'
            }
            It "has action_id `"$action_id`"" {
                $datepicker.action_id | Should Be $action_id
            }
            It "has property count $propertyCount" {
                $datepicker.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($datepicker.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $datepicker | ConvertTo-Json -Depth 100
            } 
        }
        Context "Slack Date Picker Element with placeholder | Unit Tests" {

            $properties = ("type", "action_id", "placeholder")
            $propertyCount = $properties.Count
    
            It "has a type of datepicker" {
                $datepickerWithPlaceholder.type | Should Be 'datepicker'
            }
            It "has action_id `"$action_id1`"" {
                $datepickerWithPlaceholder.action_id | Should Be $action_id1
            }
            It "has placeholder of $placeholder" {
                $datepickerWithPlaceholder.placeholder | Should Be $placeholder
            }
            It "has property count $propertyCount" {
                $datepickerWithPlaceholder.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($datepickerWithPlaceholder.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $datepickerWithPlaceholder | ConvertTo-Json -Depth 100
            } 
        }
        Context "Slack Date Picker Element with initial_date | Unit Tests" {

            $properties = ("type", "action_id", "initial_date")
            $propertyCount = $properties.Count
    
            It "has a type of datepicker" {
                $datepickerWithInitialDate.type | Should Be 'datepicker'
            }
            It "has action_id `"$action_id2`"" {
                $datepickerWithInitialDate.action_id | Should Be $action_id2
            }
            It "has initial date of $initialdate" {
                $datepickerWithInitialDate.initial_date | Should Be $initialdate
            }
            It "has property count $propertyCount" {
                $datepickerWithInitialDate.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($datepickerWithInitialDate.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $datepickerWithInitialDate | ConvertTo-Json -Depth 100
            }
        }
        Context "Slack Date Picker Element with initial_date | Unit Tests" {

            $properties = ("type", "action_id", "confirm")
            $propertyCount = $properties.Count
    
            It "has a type of datepicker" {
                $datepickerWithConfirm.type | Should Be 'datepicker'
            }
            It "has action_id `"$action_id3`"" {
                $datepickerWithConfirm.action_id | Should Be $action_id3
            }
            It "has property count $propertyCount" {
                $datepickerWithConfirm.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($datepickerWithConfirm.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $datepickerWithConfirm | ConvertTo-Json -Depth 100
            } 
        }
    }
}