function Remove-NullProperties {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]
        $InputObject
    )
    foreach ($object in $InputObject) {
        if ($object -is [string] -or $object.GetType().IsPrimitive) {
            $object
            return
        }
    
        $NewObject = @{ }
        $PropertyList = $object.PSObject.Properties | Where-Object { $null -ne $_.Value }
        foreach ($Property in $PropertyList) {
            $NewObject[$Property.Name] = Remove-NullProperties $Property.Value
        }
        [PSCustomObject]$NewObject 
    } 
}
function ConvertTo-NoNullsJson {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject,

        [int]
        $Depth = 2,

        [switch]
        $AsArray
    )
    begin {
        $list = [System.Collections.Generic.List[System.Object]]::new()
    }
    process {
        $list.Add((Remove-NullProperties -InputObject $InputObject))
    }
    end {
        $list | ConvertTo-Json -Depth $Depth
    }
}
$Classes = Get-ChildItem $PSScriptRoot -Recurse -Filter "*.cs"

foreach ($class in $Classes) {
    $Types += (Get-Content $class.FullName -Raw)
}
Add-Type -TypeDefinition $Types

$Blocks = @()

$titleText = [Slack.Composition.MrkdwnText]::new("*Slack PowerShell Module User Testing!*")
$titleSeciton = [Slack.Layout.Section]::new($titleText, "titleSection")
$Blocks += $titleSeciton

$divider1 = [Slack.Layout.Divider]::new("divider1")
$Blocks += $divider1

$subTitleText = [Slack.Composition.PlainText]::new("Testing stuff :smile:")
$subtitleSection = [Slack.Layout.Section]::new($subTitleText, "subTitleSection")
$subTitleAccessory = [Slack.Elements.Image]::new("https://api.slack.com/img/blocks/bkb_template_images/beagle.png", "a beagle")
$subtitleSection.accessory = $subTitleAccessory
$Blocks += $subtitleSection

$divider2 = [Slack.Layout.Divider]::new("divider2")
$Blocks += $divider2

$section3Text = [Slack.Composition.PlainText]::new("We're still testing all the things. :+:")
$section3 = [Slack.Layout.Section]::new($section3Text, "Section3")
$field1 = [Slack.Composition.PlainText]::new("Title`nContent")
$field2 = [Slack.Composition.PlainText]::new("Title`nContent")
$section3Fields = @($field1, $field2, $field1, $field2)
$section3.fields = $section3Fields
$Blocks += $section3

$buttonText = [Slack.Composition.PlainText]::new("OK")
$button = [Slack.Elements.Button]::new($buttonText, "ok")
$button2 = [Slack.Elements.Button]::new($buttonText, "ok2")
$button3 = [Slack.Elements.Button]::new($buttonText, "ok3")
$elements = @($button, $button2, $button3)
$actions = [Slack.Layout.Actions]::new($elements, "blockid123")
$Blocks += $actions

$contextElements = @($titleText, $section3Text, $subTitleAccessory)
$context = [Slack.Layout.Context]::new($contextElements)
$Blocks += $context

$modal = [Slack.Payloads.Modal]::new($subTitleText, $Blocks)


$modal | ConvertTo-NoNullsJson -Depth 100
