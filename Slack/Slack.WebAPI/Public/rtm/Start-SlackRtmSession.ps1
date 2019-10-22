function Start-SlackRtmSession {
    <#
    .SYNOPSIS
        Starts a Real Time Messaging session.
    .DESCRIPTION
        This function begins a Real Time Messaging API session 
        and reserves your application a specific URL with which to connect via websocket.
        It's user-centric and team-centric: your app connects as a specific user or bot user on a specific team.
        This method also returns a smorgasbord of data about the team, its channels, and members. 
        Some times more information than can be provided in a timely or helpful manner.
    .PARAMETER token
        Authentication token bearing required scopes.
    .PARAMETER batch_presence_aware
    	Batch presence deliveries via subscription. Enabling changes the shape of presence_change events.
    .PARAMETER include_locale
    	Set this to true to receive the locale for users and channels. Defaults to false
    .PARAMETER mpim_aware
    	Returns MPIMs to the client in the API response.
    .PARAMETER no_latest
    	Exclude latest timestamps for channels, groups, mpims, and ims. Automatically sets no_unreads to 1
    .PARAMETER no_unreads
    	Skip unread counts for each channel (improves performance).
    .PARAMETER presence_sub
        Only deliver presence events when requested by subscription.
    .PARAMETER simple_latest
        Return timestamp only for latest message object of each channel (improves performance).
    .Link
        https://api.slack.com/methods/rtm.start
    .EXAMPLE
        Start-SlackRtmSession -token $token -no_unreads $true
    .EXAMPLE
        rtm.start -token $token -include_locale $true
    #>
    [CmdletBinding()]
    param(
        [string]
        [Parameter(Mandatory = $true)]
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