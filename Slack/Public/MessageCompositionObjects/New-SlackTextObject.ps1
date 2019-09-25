function New-SlackTextObject {
    <#
    .SYNOPSIS
        Returns a Slack Text Object.
    .DESCRIPTION
        This function returns a Slack Text Object (markdown or plaint text) as a PSCustomObject ready to combine with other Slack Block Objects,
        ConvertTo-Json, and send to Slack.
    .PARAMETER type
        The formatting to use for this text object. Can be one of plain_textor mrkdwn.
    .PARAMETER text
        The text for the block. This field accepts any of the standard text formatting markup when type is mrkdwn.
    .PARAMETER emoji
        Indicates whether emojis in a text field should be escaped into the colon emoji format. This field is only usable when type is plain_text.
    .PARAMETER verbatim
        When set to false (as is default) URLs will be auto-converted into links, conversation names will be link-ified, 
        and certain mentions will be automatically parsed. Using a value of true will skip any preprocessing of this nature, 
        although you can still include manual parsing strings. This field is only usable when type is mrkdwn.
    .LINK
        https://api.slack.com/reference/messaging/composition-objects#text
    .EXAMPLE
        New-SlackTextObject -type "plain_text" -text "Hello there."
    .EXAMPLE
        New-SlackTextObjext -type "mrkdwn" -text "*Hello* _there_." -emoji $false
    #>
    [CmdletBinding()]
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