function Remove-NullProperties {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]
        $InputObject
    )
        if ($InputObject -is [string] -or $InputObject.GetType().IsPrimitive) {
            $InputObject
            return
        }

        $NewObject = @{ }
        $PropertyList = $InputObject.PSObject.Properties | Where-Object { $null -ne $_.Value }
        foreach ($Property in $PropertyList) {
            $NewObject[$Property.Name] = Remove-NullProperties $Property.Value
        }
        [PSCustomObject]$NewObject  
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
$section1 = [Slack.Layout.Section]::new($text, "blockid13", $imagee)
$divider = [Slack.Layout.Divider]::new()

$button = [Slack.Elements.Button]::new($text, "actionid123", "valuetext")
$urlButton = [Slack.Elements.Button]::WithUrl($text, "actionid456", "google.com")
$section2 = [Slack.Layout.Section]::new($text, "blockid15", $button)


$Blocks += $section
$Blocks += $divider
$Blocks += $section1
$Blocks += $divider
$Blocks += $section2

$Blocks | ConvertTo-NoNullsJson -Depth 100
