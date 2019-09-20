function Send-SlackMessage {
    <#
    .SYNOPSIS
        Sends a chat message to Slack
    .DESCRIPTION
        This function will send a message to a designated Slack Channel, public, private, or direct messages. 
        Blocks, attachments, or text can be passed in. Requires a Slack Token with appropriate scopes.
    .PARAMETER token
        Authentication token bearing required scopes.
    .PARAMETER channel
        Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name.
    .PARAMETER webhook
        A url to send the POST to. Should look like "https://hooks.slack.com/service/xxxxx"
    .PARAMETER text	
        Text of the message to send. See below for an explanation of formatting. This field is usually required, unless you're providing only attachments instead. 
    .PARAMETER as_user    	
        Pass true to post the message as the authed user, instead of as a bot. Defaults to false.
    .PARAMETER attachments
        An array of structured attachments
    .PARAMETER blocks
        An array of structured blocks
    .PARAMETER icon_emoji 
        Emoji to use as the icon for this message. Overrides icon_url. Must be used in conjunction with as_user set to false, otherwise ignored. 
    .PARAMETER icon_url
        URL to an image to use as the icon for this message. Must be used in conjunction with as_user set to false, otherwise ignored.
    .PARAMETER link_names
        Find and link channel names and usernames.
    .PARAMETER mrkdwn	
        Disable Slack markup parsing by setting to false. Enabled by default.
    .PARAMETER parse
        Change how messages are treated. Defaults to none.
    .PARAMETER reply_broadcast
        Used in conjunction with thread_ts and indicates whether reply should be made visible to everyone in the channel or conversation. Defaults to false.
    .PARAMETER thread_ts
        Provide another message's ts value to make this message a reply. Avoid using a reply's ts value; use its parent instead.
    .PARAMETER unfurl_links
        Pass true to enable unfurling of primarily text-based content.
    .PARAMETER unfurl_media
        Pass false to disable unfurling of media content.   
    .PARAMETER username
        Set your bot's user name. Must be used in conjunction with as_user set to false, otherwise ignored. 
    .LINK
        https://api.slack.com/methods/chat.postMessage
    .EXAMPLE
        Send-SlackMessage -token '' -channel '#mychannel' -text 'Hello there.'
    #>
    [cmdletbinding()]
    param(
        [string]
        $token,
    
        [string]
        $channel,

        [string]
        $webhook,

        [ValidateLength(1, 4000)]
        [string]
        $text = "no text set",

        [switch]
        $as_user,

        [pscustomobject[]]
        $attachments,

        [pscustomobject[]]
        $blocks,

        [ValidateScript( { $_.StartsWith(":") -and $_.EndsWith(":") })]
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

    $root = (Get-Item $PSScriptRoot).Parent.Parent.FullName

    $body = [PSCustomObject]@{
        text = $text
    }

    if ($as_user -and !$username) {
        $Body | Add-Member -NotePropertyName "as_user" -NotePropertyValue $true
    }
    elseif ($as_user -and $username) {
        Write-Error "as_user cannot be set with a username."
    }

    if ($attachments) {
        $Body | Add-Member -NotePropertyName "attachments" -NotePropertyValue $attachments
    }

    if ($blocks) {
        $Body | Add-Member -NotePropertyName "blocks" -NotePropertyValue $blocks
    }

    if ($icon_emoji -and !$as_user) {
        $Body | Add-Member -NotePropertyName "icon_emoji" -NotePropertyValue $icon_emoji
    }
    elseif ($icon_emoji -and $as_user) {
        Write-Error "icon_emoji cannot be used with as_user set to true"
    }

    if ($icon_url -and !$as_user) {
        $Body | Add-Member -NotePropertyName "icon_url" -NotePropertyValue $icon_url
    }
    elseif ($icon_url -and $as_user) {
        Write-Error ""
    }

    if ($username -and !$as_user) {
        $Body | Add-Member -NotePropertyName "username" -NotePropertyValue $username
    }
    elseif ($username -and $as_user) {
        Write-Error "Username cannot be set with as_user set to true."
    }

    if (!$webhook) {
        if (!$token) {
            $content = Get-Content "$root\pslickpslackconfig.json" | ConvertFrom-Json
            $token = $content.userToken
        }
        $Headers = @{
            Authorization = "Bearer $token"
        }

        if (!$channel) {
            $content = Get-Content "$root\pslickpslackconfig.json" | ConvertFrom-Json
            $channel = $content.defaultChannel
        } 
        $body | Add-Member -NotePropertyName "channel" -NotePropertyValue $channel

        Invoke-RestMethod -Method Post -Uri 'https://slack.com/api/chat.postMessage' -Headers $Headers -ContentType 'application/json;charset=iso-8859-1' -Body ($Body | ConvertTo-Json -Depth 100)
    }
    #Webhooks take precedence (for now). 
    else {
        Invoke-RestMethod -Method Post -Uri $webhook -ContentType 'application/json;charset=iso-8859-1' -Body ($Body | ConvertTo-Json -Depth 100)
    }
     


}
