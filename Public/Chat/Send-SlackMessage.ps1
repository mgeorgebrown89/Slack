function Send-SlackMessage {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        [string]
        $token,
    
        [parameter(Mandatory)]
        [string]
        $channel,

        [ValidateLength(1, 4000)]
        [string]
        $text,

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

    $Headers = @{
        Authorization = "Bearer $token"
    }

    # Construct the Body based on parameters
    $Body = [PSCustomObject]@{
        channel = $channel
        text    = "placeholder text"
    }

    if ($text) {
        $Body.text = $text
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

    if($icon_url -and !$as_user){
        $Body | Add-Member -NotePropertyName "icon_url" -NotePropertyValue $icon_url
    }
    elseif ($icon_url -and $as_user){
        Write-Error
    }

    if ($username -and !$as_user) {
        $Body | Add-Member -NotePropertyName "username" -NotePropertyValue $username
    }
    elseif($username -and $as_user) {
        Write-Error "Username cannot be set with as_user set to true."
    }

    Invoke-RestMethod -Method Post -Uri 'https://slack.com/api/chat.postMessage' -Headers $Headers -ContentType 'application/json;charset=iso-8859-1' -Body ($Body | ConvertTo-Json -Depth 100)
}