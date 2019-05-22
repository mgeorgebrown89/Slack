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

        [pscustomobject[]]
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

        [switch]
        $unfurl_links,

        [bool]
        $unfurl_media = $true,

        [string]
        $username
    )

    $Headers = @{
        Authorization = "Bearer $token"
    }

    $Body = @{
        channel = $channel
        blocks = $blocks
    }

    Invoke-RestMethod -Method Post -Uri 'https://slack.com/api/chat.postMessage' -Headers $Headers -ContentType "application/json" -Body ($Body | ConvertTo-Json -Depth 100)
}
