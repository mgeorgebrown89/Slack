function Send-SlackMessage {
    <#
    .SYNOPSIS
        Sends a message to Slack.
    .DESCRIPTION
        This function sends a Slack.Payloads.Message object to a Slack Channel.
    .PARAMETER Token
        A Slack User or Bot User Token.
    .PARAMETER Message
        A Slack.Payloads.Message object to send to Slack.
    .LINK
        https://api.slack.com/methods/chat.postMessage
    .EXAMPLE
        Send-SlackMessage -Token $Token -Message $Message
    .EXAMPLE
        chat.postMessage -Token $Token -Message $Message
    #>
    [cmdletbinding()]
    param(
        [string]
        [ValidatePattern("((^(xox)(p|b)(-(\w){12}){3}-(\w){32})$)|((^(xox)(p|b)(-(\w){12}){2}-(\w){24})$)")]
        $Token,

        [Slack.Payloads.Message]
        $Message
    )
    Invoke-SlackWebAPI -Token $Token -Method_Family "chat.postMessage" -Body $Message
}
Set-Alias -Name 'chat.postMessage' -Value 'Send-SlackMessage'