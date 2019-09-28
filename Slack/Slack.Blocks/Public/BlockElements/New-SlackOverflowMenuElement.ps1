function New-SlackOverflowMenuElement {
    <#
    .SYNOPSIS
        Returns a Slack Overflow Menu.
    .DESCRIPTION
        This function returns a Slack Overflow Menu Element as a PSCustomObject ready to combine with other Slack Blocks,
        ConvertTo-Json, and send to Slack.
    .PARAMETER action_id
        An identifier for the action triggered when a menu option is selected. 
    .PARAMETER options
        An array of option objects.
    .PARAMETER confirm
        A confirm object that defines an optional confirmation dialog that appears after a menu item is selected.
    .LINK
        https://api.slack.com/reference/messaging/block-elements#overflow
    .EXAMPLE
        New-SlackOverflowMenuElement -action_id "overflow321" -options $options -confirm $comfirmationDialogObject
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1, 255)]
        $action_id,

        [Parameter(Mandatory)]
        [ValidateLength(2, 5)]
        [pscustomobject[]]
        $options,

        [pscustomobject]
        $confirm
    )

    $SlackOverflowMenu = [pscustomobject]@{
        type    = "overflow"
        options = $options
    }

    if ($confirm) {
        $SlackOverflowMenu.confirm = $confirm
    }
    
    return $SlackOverflowMenu
}