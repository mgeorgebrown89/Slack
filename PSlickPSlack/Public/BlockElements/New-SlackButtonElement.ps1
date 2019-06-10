function New-SlackButtonElement {
<#
.SYNOPSIS
    Returns a Slack Button PSCustomObject.
.DESCRIPTION
    This function returns a Slack Button as a PSCustomObject ready to ConvertTo-Json and be sent to Slack.
.EXAMPLE
    Get-SlackButtonElement -text "Yes" -action_id "affirmThis"
.EXAMPLE
    Get-SlackButtonElement -text "No" -action_id "denyThis" -value "0001" -style "danger"
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1, 75)]
        [string]
        $text,

        [Parameter(Mandatory)]
        [ValidateLength(1, 255)]
        [string]
        $action_id,

        [ValidateLength(1, 3000)]
        [string]
        $url,

        [ValidateLength(1, 2000)]
        [string]
        $value,

        [ValidateSet("primary", "danger")]
        [string]
        $style,

        [pscustomobject]
        $confirm
    )

    $SlackButton = [pscustomobject]@{
        type      = "button"
        text      = New-SlackTextObject -type plain_text -text $text -emoji $true
        action_id = $action_id
    }

    if ($url) {
        $SlackButton | Add-Member -NotePropertyName "url" -NotePropertyValue $url
    }
    if ($value) {
        $SlackButton | Add-Member -NotePropertyName "value" -NotePropertyValue $value
    }
    if ($style) {
        $SlackButton | Add-Member -NotePropertyName "style" -NotePropertyValue $style
    }
    if ($confirm) {
        $SlackButton | Add-Member -NotePropertyName "confirm" -NotePropertyValue $confirm
    }

    return $SlackButton
}