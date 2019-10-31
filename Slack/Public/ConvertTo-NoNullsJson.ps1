function ConvertTo-NoNullsJson {
    <#
    .SYNOPSIS
        Converts an object into JSON format without any null key value pairs.
    .DESCRIPTION
        This function takes a PowerShell Object and passes it to Remove-NullProperties.
        This removes all the properties with null values, and outputs the JSON. 
        This is for use with APIs that don't like null values.
    .PARAMETER InputObject
        The object from which to remove null properties. 
    .PARAMETER Depth
        An integer representing the level of objects to convert to JSON. This is the same of the ConvertTo-Json cmdlet.
    .EXAMPLE
        $SomeObject | ConvertTo-NoNullsJson -Depth 5
    #>
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
        if ($AsArray) {
            $list | ConvertTo-Json -Depth $Depth -AsArray
        }
        else {
            $list | ConvertTo-Json -Depth $Depth
        }
    }
}