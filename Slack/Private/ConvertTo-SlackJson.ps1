function ConvertTo-SlackJson {
    [CmdletBinding()]
    param(
        $object
    )

    $object | ForEach-Object {

        $NonEmptyProperties = $_.psobject.Properties | Where-Object {$null -ne $_.Value} | Select-Object -ExpandProperty Name
    
        # Convert object to JSON with only non-empty properties
        $_ | Select-Object -Property $NonEmptyProperties | ConvertTo-Json
    }
}