function Open-SlackView {
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