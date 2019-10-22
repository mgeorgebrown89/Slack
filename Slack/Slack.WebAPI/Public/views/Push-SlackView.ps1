function Push-SlackView {
    <#
    .SYNOPSIS 
        Push a view onto the stack of a root view.
    .DESCRIPTION
        This function pushes a new view onto the existing view stack 
        by passing a view payload and a valid trigger_id generated from an interaction within the existing modal. 
        The pushed view is added to the top of the stack, 
        so the user will go back to the previous view after they complete or cancel the pushed view.
        After a modal is opened, the app is limited to pushing 2 additional views.
    .PARAMETER Token
        Authentication token bearing required scopes.
    .PARAMETER trigger_id
        Exchange a trigger to post to the user.
    .PARAMETER view
        The view payload. Must be of type [Slack.Payloads.View]
    .LINK
        https://api.slack.com/methods/views.push
    .EXAMPLE
        Push-SlackView -token $token -tiggerId '12345.98765.abcd2358fdea' -view $view
    .EXAMPLE 
        views.push -token $token -tiggerId '12345.98765.abcd2358fdea' -view $view
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
    
    Invoke-SlackWebAPI -Token $Token -Method_Family "views.push" -Body $Body
}
Set-Alias -Name 'views.push' -Value 'Push-SlackView'