function New-SlackStaticSelectMenuElement {
    <#
    .SYNOPSIS
        Returns a Slack Static Select Menu.
    .DESCRIPTION
        This function returns a Slack Static Select Menu Element as a PSCustomObject ready to combine with other Slack Blocks,
        ConvertTo-Json, and send to Slack.
    .PARAMETER placeholder
        Text that defines the placeholder text shown on the menu.
    .PARAMETER action_id
        An identifier for the action triggered when a menu option is selected. 
    .PARAMETER options
        An array of option objects.
    .PARAMETER option_groups
        An array of option group objects.
    .PARAMETER initial_option
        A single option that exactly matches one of the options within options or option_groups. This option will be selected when the menu initially loads.
    .PARAMETER confirm
        A confirm object that defines an optional confirmation dialog that appears after a menu item is selected.
    .LINK
        https://api.slack.com/reference/messaging/block-elements#static-select
    .EXAMPLE
        New-SlackStaticSelectMenuElement -placeholder "Select an option" -action_id "selection123" -options $options -initial_option "Buidling12"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1, 150)]
        [string]
        $placeholder,

        [Parameter(Mandatory)]
        [ValidateLength(1, 255)]
        $action_id,

        [Parameter(Mandatory)]
        [ValidateLength(1, 100)]
        [pscustomobject[]]
        $options,

        [Parameter(Mandatory)]
        [ValidateLength(1, 100)]
        [pscustomobject[]]
        $option_groups,

        [pscustomobject]
        $initial_option,

        [pscustomobject]
        $confirm
    )

    $SlackStaticSelect = [pscustomobject]@{
        type        = "static_select"
        action_id   = $action_id
        placeholder = @{
            type = "plain_text"
            text = $placeholder
        }
    }

    if (!$option_groups -and $options) {
        $SlackStaticSelect.options = $options
    }
    elseif (!$options -and $option_groups) {
        $SlackStaticSelect.option_groups = $option_groups
    }
    else {
        Write-Error "You can't have both options and option groups in a Static Select Element."
    }

    if ($initial_option) {
        $SlackStaticSelect.initial_option = $initial_option
    }
    if ($confirm) {
        $SlackStaticSelect.confirm = $confirm
    }

    return $SlackStaticSelect
}