function Send-SlackMessage {
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