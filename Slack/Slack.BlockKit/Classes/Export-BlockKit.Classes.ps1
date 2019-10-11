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
Add-Type -TypeDefinition $Types #-ErrorAction SilentlyContinue