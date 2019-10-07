function ConvertTo-NoNullsJson {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [object[]]
        $InputObject,

        [int]
        $Depth = 2,

        [switch]
        $AsArray
    )
    begin{
        $array = @()
    }
    process {
        $array += $InputObject | ForEach-Object {
            $NonEmptyProperties = $_.psobject.Properties | Where-Object { $null -ne $_.Value } | Select-Object -ExpandProperty Name
            $_ | Select-Object -Property $NonEmptyProperties
        } 
    }
    end {
        $array | ConvertTo-Json -Depth $Depth 
    }
}
$Classes = Get-ChildItem $PSScriptRoot -Recurse -Filter "*.cs"

foreach($class in $Classes){
    $Types += (Get-Content $class.FullName -Raw)
}
Add-Type -TypeDefinition $Types

$Blocks = @()
$text = [Slack.Composition.PlainText]::new("this is plain text!")
$section = [Slack.Layout.Section]::new($text,"blockid123")
$imagee = [Slack.Elements.Image]::new("https://api.slack.com/img/blocks/bkb_template_images/palmtree.png","plam tree")
$section1 = [Slack.Layout.Section]::new($text,"blockid13",$imagee)
$divider = [Slack.Layout.Divider]::new()

$Blocks += $section
$Blocks += $divider
$Blocks += $section1

$Blocks | ConvertTo-NoNullsJson
