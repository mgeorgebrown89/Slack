function Test-SlackWebAPI {
    <#
    .SYNOPSIS
        Checks API calling code.
    .DESCRIPTION
        This function helps test your calling code.
    .PARAMETER Token
        A Slack API Token
    .PARAMETER Body
        A PowerShell object containing the calling code arguments.
    .LINK
        https://api.slack.com/methods/api.test
    .EXAMPLE 
        Test-SlackWebAPI -Token $Token -Body $Body
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