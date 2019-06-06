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

Describe "$functionName | Unit Tests" -Tags "Unit" {

    Context "Slack Image Element | Unit tests" {

        $alt_text = "This is a Slack Image Block"
        $image_url = "https://raw.githubusercontent.com/mgeorgebrown89/PSlickPSlack/master/Media/PSlickPSlack_icon.png"
        $imageBlock = New-SlackImageBlock -image_url $image_url -alt_text $alt_text
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

        $alt_text = "This is a Slack Image Block with a Title and block_id"
        $image_url = "https://raw.githubusercontent.com/mgeorgebrown89/PSlickPSlack/master/Media/PSlickPSlack_icon.png"
        $title = "This is the title of the Slack Image Block"
        $block_id = "imageblock123"
        $imageBlock = New-SlackImageBlock -image_url $image_url -alt_text $alt_text -title $title -block_id $block_id
        $properties = ("type", "image_url", "alt_text", "title", "block_id")
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
        It "has title `"$title`"" {
            $imageBlock.title.text | Should Be $title
        }
        It "has block_id `"$block_id`"" {
            $imageBlock.block_id | Should Be $block_id
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
}

Describe "$functionName | Acceptance Tests" -Tags "Acceptance" {

    Context "Slack Image Element | Acceptance tests" {

        $alt_text = "This is a Slack Image Block"
        $image_url = "https://raw.githubusercontent.com/mgeorgebrown89/PSlickPSlack/master/Media/PSlickPSlack_icon.png"
        $Blocks = @()
        $Blocks += New-SlackImageBlock -image_url $image_url -alt_text $alt_text

        $Body = @{
            blocks = $Blocks
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

    Context "Slack Image Element with a Title and block_id| Acceptance tests" {

        $alt_text = "This is a Slack Image Block"
        $image_url = "https://raw.githubusercontent.com/mgeorgebrown89/PSlickPSlack/master/Media/PSlickPSlack_icon.png"
        $title = "This is the title of the Slack Image Block"
        $block_id = "imageblock456"
        $Blocks = @()
        $Blocks += New-SlackImageBlock -image_url $image_url -alt_text $alt_text -title $title -block_id $block_id

        $Body = @{
            blocks = $Blocks
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