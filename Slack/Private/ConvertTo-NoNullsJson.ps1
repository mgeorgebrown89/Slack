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
