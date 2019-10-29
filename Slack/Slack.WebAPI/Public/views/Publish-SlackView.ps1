function Publish-SlackView {
    <#
    .SYNOPSIS 
        Publish a static view for a User.
    .DESCRIPTION
        This function creates or updates the view that comprises an app's Home tab for a specific user.
    .PARAMETER Token
        Authentication token bearing required scopes.
    .PARAMETER user_id
        id of the user you want publish a view to.
    .PARAMETER view
        The view payload. Must be of type [Slack.Payloads.View]
    .PARAMETER hash
        A string that represents view state to protect against possible race conditions.  
    .LINK
        https://api.slack.com/methods/views.publish
    .EXAMPLE
        Publish-SlackView -token $token -view $view
    .EXAMPLE 
        views.publish -token $token -view $view
    #>
    [CmdletBinding()]
    param(
        [string]
        $Token,

        [string]
        $user_id,

        [Slack.Payloads.View]
        $view,

        [string]
        $hash
    )

    $Body = [PSCustomObject]@{
        user_id = $user_id
        view    = $view
        hash    = $hash
    }
    
    Invoke-SlackWebAPI -Token $Token -Method_Family "views.publish" -Body $Body
}
Set-Alias -Name 'views.publish' -Value 'Publish-SlackView'