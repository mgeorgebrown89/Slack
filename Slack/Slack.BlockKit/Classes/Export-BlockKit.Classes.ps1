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
$text = [Slack.Composition.PlainText]::new("this is plain text!")
$section = [Slack.Layout.Section]::new($text, "blockid123")
$imagee = [Slack.Elements.Image]::new("https://api.slack.com/img/blocks/bkb_template_images/palmtree.png", "plam tree")
$section1 = [Slack.Layout.Section]::new($text, "blockid13")
$section1.accessory = $imagee
$divider = [Slack.Layout.Divider]::new()

$button = [Slack.Elements.Button]::new($text, "actionid123")
$button.value = "valueText"
$urlButton = [Slack.Elements.Button]::new($text, "actionid456")
$urlButton.url = "https://www.google.com/"
$section2 = [Slack.Layout.Section]::new($text, "blockid15")
$section2.accessory = $button
$section3 = [Slack.Layout.Section]::new($text, "blockid156")
$options = @()
$option1 = [Slack.Composition.Option]::new($text, "hello")
$option2 = [Slack.Composition.Option]::new($text, "hel111lo")
$options += $option1
$options += $option2
$optionsGroups = @()
$optionGroup1 = [Slack.Composition.OptionGroup]::new($text,$options)
$optionGroup2 = [Slack.Composition.OptionGroup]::new($text,$options)
$optionsGroups += $optionGroup1
$optionsGroups += $optionGroup2
$staticSelect = [Slack.Elements.StaticSelect]::new($text, "action999", $optionsGroups)
$staticSelect.initial_option = $option1
$section3.accessory = $staticSelect

$Blocks += $section1
$Blocks += $section2
$Blocks += $section3

$Blocks | ConvertTo-NoNullsJson -Depth 100
