function Update-SlackView {
    <#
    .SYNOPSIS 
        Update an existing view.
    .DESCRIPTION
        This function updates a view by passing a new view definition 
        along with the view_id returned in views.open or the external_id.
    .PARAMETER Token
        Authentication token bearing required scopes.
    .PARAMETER view
        The view payload. Must be of type [Slack.Payloads.View]
    .PARAMETER external_id
        A unique identifier of the view set by the developer.
        Must be unique for all views on a team. Max length of 255 characters. 
        Either view_id or external_id is required.
    .PARAMETER hash
        A string that represents view state to protect against possible race conditions.  
    .PARAMETER view_id
        A unique identifier of the view to be updated. 
        Either view_id or external_id is required.
    .LINK
        https://api.slack.com/methods/views.open
    .EXAMPLE
        Push-SlackView -token $token -tiggerId '12345.98765.abcd2358fdea' -view $view
    .EXAMPLE 
        views.push -token $token -tiggerId '12345.98765.abcd2358fdea' -view $view
    #>
    [CmdletBinding()]
    param(
        [string]
        $Token,

        [Slack.Payloads.View]
        $view,

        [ValidateLength(0, 255)]
        [string]
        $external_id,

        [string]
        $hash,

        [string]
        $view_id
    )
    if ($view_id -and !$external_id) {
        $Body = [PSCustomObject]@{
            view    = $view
            hash    = $hash
            view_id = $view_id
        }
    }
    elseif ($external_id -and !$view_id) {
        $Body = [PSCustomObject]@{
            view        = $view
            external_id = $external_id
            hash        = $hash
        }
    }
    else {
        Write-Error "You can't use both view_id and external_id."
    }
    
    Invoke-SlackWebAPI -Token $Token -Method_Family "views.update" -Body $Body
}
Set-Alias -Name 'views.update' -Value 'Update-SlackView'