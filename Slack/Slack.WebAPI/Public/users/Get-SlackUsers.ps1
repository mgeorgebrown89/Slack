function Get-SlackUsers {
    <#
    .SYNOPSIS
        Lists all users in a Slack team.
    .DESCRIPTION
        This function returns a list of all users in the Slack workspace. This includes deleted/deactivated users.
    .PARAMETER token
    	Authentication token bearing required scopes.
    .PARAMETER cursor
        Paginate through collections of data by setting the cursor parameter to a next_cursor attribute 
        returned by a previous request's response_metadata. 
        Default value fetches the first "page" of the collection. 
    .PARAMETER include_locale
    	Set this to true to receive the locale for users. Defaults to false
    .PARAMETER limit
        The maximum number of items to return. Fewer than the requested number of items may be returned, 
        even if the end of the users list hasn't been reached.
    .LINK
        https://api.slack.com/methods/users.list
    .EXAMPLE
        Get-SlackUsers -token $token
    .EXAMPLE
        users.list -token $token -limit 20
    #>
    [CmdletBinding()]
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $Token,

        [string]
        $cursor,

        [bool]
        $include_locale = $false,

        [int]
        $limit = 0
    )

    $Body = "cursor=$cursor&include_local=$include_local&limit=$limit"
    
    Invoke-SlackWebAPI -Token $Token -Method_Family "users.list" -REST_Method "POST" -Body $Body -ContentType "application/x-www-form-urlencoded"
}
Set-Alias -Name 'users.list' -Value 'Get-SlackUsers'