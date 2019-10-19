function Push-SlackView {
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