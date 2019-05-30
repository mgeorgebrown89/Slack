function New-SlackTextObject {
    param(
        [Parameter(Mandatory)]
        [ValidateSet("plain_text","mrkdwn")]
        [string]
        $type,

        [Parameter(Mandatory)]
        [string]
        $text,

        [bool]
        $emoji = $true,
        
        [bool]
        $verbatim = $false
    )

    $SlackTextObject = [pscustomobject]@{
        type = $type
        text = $text
    }

    if($type -eq "plain_text"){
        $SlackTextObject | Add-Member -NotePropertyName "emoji" -NotePropertyValue $emoji
    }
    elseif($type -eq "mrkdwn"){
        $SlackTextObject | Add-Member -NotePropertyName "verbatim" -NotePropertyValue $verbatim
    }
    return $SlackTextObject
}