function Connect-SlackRtmSession {
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