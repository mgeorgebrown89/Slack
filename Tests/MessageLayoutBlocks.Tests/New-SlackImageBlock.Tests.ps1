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
        $root = Split-Path -Parent (Split-Path -Parent ((Split-Path -Parent $MyInvocation.MyCommand.Path)))
        $slackContent = Get-Content $root\slacktoken.json | ConvertFrom-Json
        $SlackUri = $slackContent.slackwebhook
        $SlackHeaders = @{Authorization = ("Bearer " + $slackContent.slacktoken) }
    }
    $slackTestUri = "https://slack.com/api/api.test" 
    $ContentType = "application/json; charset=utf-8"

    #imageblock
    $alt_text = "This is a Slack Image Block"
    $image_url = "https://raw.githubusercontent.com/mgeorgebrown89/PSlickPSlack/master/Media/PSlickPSlack_icon.png"
    $imageBlock = New-SlackImageBlock -image_url $image_url -alt_text $alt_text

    #image block with Title and block_id
    $alt_text1 = "This is a Slack Image Block with a Title and block_id"
    $image_url1 = "https://raw.githubusercontent.com/mgeorgebrown89/PSlickPSlack/master/Media/PSlickPSlack_icon.png"
    $title = "This is the title of the Slack Image Block"
    $block_id = "imageblock123"
    $imageBlockWithTitleAndBlockId = New-SlackImageBlock -image_url $image_url1 -alt_text $alt_text1 -title $title -block_id $block_id

}
process {
    Describe "$functionName | Unit Tests" -Tags "Unit" {

        Context "Slack Image Block | Unit tests" {
    
            $properties = ("type", "image_url", "alt_text")
            $propertyCount = $properties.Count
    
            It "has a type of image" {
                $imageBlock.type | Should Be 'image'
            }
            It "has valid image_url `"$image_url`"" {
                $imageBlock.image_url | Should Be $image_url
            }
            It "has alt_text `"$alt_text`"" {
                $imageBlock.alt_text | Should Be $alt_text
            }
            It "has property count $propertyCount" {
                $imageBlock.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($imageBlock.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $block | ConvertTo-Json -Depth 100
            }
        }
    
        Context "Slack Image Element with Title and block_id | Unit Tests" {
    
            $properties = ("type", "image_url", "alt_text", "title", "block_id")
            $propertyCount = $properties.Count
    
            It "has a type of image" {
                $imageBlockWithTitleAndBlockId.type | Should Be 'image'
            }
            It "has valid image_url `"$image_url`"" {
                $imageBlockWithTitleAndBlockId.image_url | Should Be $image_url1
            }
            It "has alt_text `"$alt_text1`"" {
                $imageBlockWithTitleAndBlockId.alt_text | Should Be $alt_text1
            }
            It "has title `"$title`"" {
                $imageBlockWithTitleAndBlockId.title.text | Should Be $title
            }
            It "has block_id `"$block_id`"" {
                $imageBlockWithTitleAndBlockId.block_id | Should Be $block_id
            }
            It "has property count $propertyCount" {
                $imageBlockWithTitleAndBlockId.PSObject.Properties.Name | Should -HaveCount $properties.Count
            }
            foreach ($property in $properties) {
                It "has a $property property" {
                    [bool]($imageBlockWithTitleAndBlockId.PSObject.Properties.Name -match $property) | Should Be $true
                }
            }
            It "is valid JSON" {
                $imageBlockWithTitleAndBlockId | ConvertTo-Json -Depth 100
            }
        }
    }
    
    Describe "$functionName | Acceptance Tests" -Tags "Acceptance" {
    
        Context "Slack Image Element | Acceptance tests" {
    
            $Blocks = @()
            $Blocks += $imageBlock
            $Body = @{
                blocks = $Blocks
            }
    
            It "returns http 200 response" {
                $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100)
                $response.ok | Should Be "true"
                $response.warning | Should Be $null
            }
        }
    
        Context "Slack Image Element with a Title and block_id | Acceptance tests" {
    
            $Blocks = @()
            $Blocks += $imageBlockWithTitleAndBlockId
            $Body = @{
                blocks = $Blocks
            }
    
            It "returns http 200 response" {
                $response = Invoke-RestMethod -Method Post -Uri $slackTestUri -Headers $SlackHeaders -ContentType $ContentType -Body ($Body | ConvertTo-Json -Depth 100)
                $response.ok | Should Be "true"
                $response.warning | Should Be $null
            }
        }
    }
}