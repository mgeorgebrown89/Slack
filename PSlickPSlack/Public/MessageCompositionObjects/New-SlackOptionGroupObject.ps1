function New-SlackOptionGroupObject {
    <#
    .SYNOPSIS
        Returns a Slack Option Group Object.
    .DESCRIPTION
        This function returns a Slack Option Group Object as a PSCustomObject ready to combine with select menus,
        ConvertTo-Json, and send to Slack.
    .PARAMETER label
        Text that defines the label shown above this group of options.
    .PARAMETER slackOptions
        An array of option objects that belong to this specific group.
    .LINK
        https://api.slack.com/reference/messaging/composition-objects#option-group
    .EXAMPLE
        New-SlackOptionGroupObject -label "Jedis" -value $Jedis
    #>
    [CmdletBinding()]
    param(
        [ValidateLength(1, 75)]
        [string]
        $label,

        [ValidateLength(1, 100)]
        [pscustomobject[]]
        $SlackOptions
    )

    $SlackOptionGroup = [pscustomobject]@{
        label   = New-SlackTextObject -type plain_text -text $label
        options = $SlackOptions
    }
    return $SlackOptionGroup
}