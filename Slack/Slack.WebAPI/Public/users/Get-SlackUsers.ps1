function Get-SlackUsers {
    [CmdletBinding()]
    param(
        [string]
        $Token
    )

    Invoke-SlackWebAPI -Token $Token -Method_Family "users.list" -REST_Method "GET"
}
Set-Alias -Name 'users.list' -Value 'Get-SlackUsers'