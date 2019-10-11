function Send-SlackMeMessage{
    <#
    .SYNOPSIS
        Sends a Me Message to Slack.
    .DESCRIPTION
        This function sends a Me Message (italisized message) to a Slack channel.
    .PARAMETER Token
        A Slack User Token.
    .PARAMETER Channel
        A Slack Channel name or ID.
    .PARAMETER Text
        The text of the Me Message to send implying an action undertaken by the user. 
    .LINK
        https://api.slack.com/methods/chat.meMessage
    .EXAMPLE
        Send-SlackMeMessage -Token $Token -Channel 'pslickpslack-testing' -Text "does a little jig."
    .EXAMPLE
        chat.meMessage -Token $Token -Channel 'pslickpslack-testing' -Text "gets down tonight."
    #>
    [CmdletBinding()]
    param(
        [string]
        $Token,

        [string]
        $Channel,

        [string]
        $Text
    )

    $Body = [PSCustomObject]@{
        channel = $Channel
        text = $Text
    }

    Invoke-SlackWebAPI -Token $Token -Method_Family "chat.meMessage" -Body $Body
}
Set-Alias -Name "chat.meMessage" -Value "Send-SlackMeMessage"