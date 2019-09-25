function Test-SlackWebAPI {
    <#
    #>
    [CmdletBinding()]
    param(
        [string]
        $Token,

        [PSCustomObject]
        $Body
    )

    Invoke-SlackWebAPI -Token $Token -Method_Family "api.test" -Body $Body
}