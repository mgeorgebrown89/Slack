function Open-SlackView {
    <#
    .SYNOPSIS 
        Open a view for a user.
    .DESCRIPTION
        This function opens a modal with a user by exchanging a trigger_id received from another interaction. 
    .PARAMETER Token
        Authentication token bearing required scopes.
    .PARAMETER trigger_id
        Exchange a trigger to post to the user.
    .PARAMETER view
        The view payload. Must be of type [Slack.Payloads.View]
    .LINK
        https://api.slack.com/methods/views.open
    .EXAMPLE
        Open-SlackView -token $token -tiggerId '12345.98765.abcd2358fdea' -view $view
    .EXAMPLE 
        views.open -token $token -tiggerId '12345.98765.abcd2358fdea' -view $view
    #>
    [CmdletBinding()]
    param(
        [string]
        $Token,

        [string]
        $trigger_id,

        [Slack.Payloads.View]
        $view
    )

    $Body = @{
        trigger_id = $trigger_id
        view       = $view
    }
    
    Invoke-SlackWebAPI -Token $Token -Method_Family "views.open" -Body $Body
}
Set-Alias -Name 'views.open' -Value 'Open-SlackView'