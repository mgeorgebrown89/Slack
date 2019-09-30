function New-SlackOptionObject {
    <#
    .SYNOPSIS
        Returns a Slack Option Object.
    .DESCRIPTION
        This function returns a Slack Option Object as a PSCustomObject ready to combine with select menus and overflow menus,
        ConvertTo-Json, and send to Slack.
    .PARAMETER text
        Text that defines the text shown in the option on the menu.
    .PARAMETER value
        The string value that will be passed to your app when this option is chosen.
    .PARAMETER url
        A URL to load in the user's browser when the option is clicked. The url attribute is only available in overflow menus.
    .LINK
        https://api.slack.com/reference/messaging/composition-objects#option
    .EXAMPLE
        New-SlackOptionObject -text "Hello there." -value "Obi1"
    #>
    [CmdletBinding()]
    param(
        [ValidateLength(1, 75)]
        [string]
        $text,

        [ValidateLength(1, 75)]
        [string]
        $value,

        [string]
        $url
    )

    $SlackOption = [pscustomobject]@{
        text  = New-SlackTextObject -type plain_text -text $text
        value = $value
    }

    if($url){
        $SlackOption | Add-Member -NotePropertyName "url" -NotePropertyValue $url
    }

    return $SlackOption
}