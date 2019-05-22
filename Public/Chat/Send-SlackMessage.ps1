function Send-SlackMessage {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        [string]
        $token,
    
        [parameter(Mandatory)]
        [string]
        $channel,

        [ValidateLength(1,4000)]
        [string]
        $text,

        [switch]
        $as_user,

        [pscustomobjectp[]]
        $attachments,

        [pscustomobject[]]
        $blocks,

        [string]
        $icon_emoji,

        [string]
        $icon_url,

        [switch]
        $link_names,

        [bool]
        $mrkdwn = $true,

        [string]
        $parse = "none",

        [switch]
        $reply_broadcast,

        [string]
        $thread_ts,

        [swtich]
        $unfurl_links,

        [bool]
        $unfurl_media = $true,

        [string]
        $username
    )

    Invoke-RestMethod -Method Post -Uri 
}