function Update-SlackView {
    [CmdletBinding()]
    param(
        [string]
        $Token,

        [Slack.Payloads.View]
        $view,

        [string]
        [ValidateLength(255)]
        $external_id,

        [string]
        $hash,

        [string]
        $view_id
    )

    $Body = @{
        view        = $view
        external_id = $external_id
        hash        = $hash
        view_id     = $view_id
    }
    
    Invoke-SlackWebAPI -Token $Token -Method_Family "views.update" -Body $Body
}
Set-Alias -Name 'views.update' -Value 'Update-SlackView'