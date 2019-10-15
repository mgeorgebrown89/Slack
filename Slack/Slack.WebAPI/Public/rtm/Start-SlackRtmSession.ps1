function Start-SlackRtmSession {
    [CmdletBinding()]
    param(
        [string]
        $token,

        [switch]
        $batch_presence_aware,

        [switch]
        $include_locale,

        [switch]
        $mpim_aware,

        [switch]
        $no_latest,
        
        [bool]
        $no_unreads,

        [bool]
        $presence_sub,

        [bool]
        $simple_latest
    )

    Invoke-SlackWebApi -Token $token -REST_Method 'GET' -Method_Family 'rtm.start'
}
Set-Alias -Name 'rtm.start' -Value 'Start-SlackRtmSession'