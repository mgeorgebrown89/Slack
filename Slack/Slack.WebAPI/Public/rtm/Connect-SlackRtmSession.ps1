function Connect-SlackRtmSession {
    <#
    .SYNOPSIS 
        Starts a Real Time Messaging Session.
    .DESCRIPTION
        This function beings a Real Time Messaging Session with Slack 
        and reserves your application a specific URL with which to connect via websocket.
        Unlike rtm.start, this method is focused only on connecting to the RTM API.
    .PARAMETER token
        A Slack User or Bot token.
    .PARAMETER batch_presence_aware
        Batch presence deliveries via subscription. Enabling changes the shape of presence_change events.
    .PARAMETER presence_sub
        Only deliver presence events when requested by subscription.
    .LINK
        https://api.slack.com/methods/rtm.connect
    .EXAMPLE
        Connect-SlackRtmSession -token $Token
    .EXAMPLE
        rtm.connect -token $Token
    #>
    [CmdletBinding()]
    param(
        [string]
        $token,

        [bool]
        $batch_presence_aware,

        [bool]
        $presence_sub
    )

    Invoke-SlackWebApi -Token $token -REST_Method 'GET' -Method_Family 'rtm.connect'
}
Set-Alias -Name 'rtm.connect' -Value 'Connect-SlackRtmSession'