function New-SlackExternalSelectMenuElement {
    <#
    .SYNOPSIS
        Returns a Slack External Select Menu.
    .DESCRIPTION
        This function returns a Slack External Select Menu Element as a PSCustomObject ready to combine with other Slack Blocks,
        ConvertTo-Json, and send to Slack.
    .PARAMETER placeholder
        Text that defines the placeholder text shown on the menu. 
    .PARAMETER action_id
        An identifier for the action triggered when a menu option is selected.
    .PARAMETER initial_option
        A single option that exactly matches one of the options within the options or option_groups loaded from the external data source. 
        This option will be selected when the menu initially loads.
    .PARAMETER min_query_length
        When the typeahead field is used, a request will be sent on every character change. 
        If you prefer fewer requests or more fully ideated queries, 
        use the min_query_length attribute to tell Slack the fewest number of typed characters required before dispatch.
    .PARAMETER confirm
    	A confirm object that defines an optional confirmation dialog that appears after a menu item is selected.
    .LINK
        https://api.slack.com/reference/messaging/block-elements#external-select
    .EXAMPLE
        New-SlackExternalSelectMenuElement -placeholder "Select an object:" -action_id "ex456" -initial_option $option1 -min_query_length 3
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1, 150)]
        [string]
        $placeholder,

        [Parameter(Mandatory)]
        [ValidateLength(1, 255)]
        [string]
        $action_id,

        [pscustomobject]
        $initial_option,

        [Int]
        $min_query_length,

        [pscustomobject]
        $confirm
    )

    $SlackExternalSelect = [pscustomobject]@{
        type        = "external_select"
        action_id   = $action_id
        placeholder = @{
            type = "plain_text"
            text = $placeholder
        }
    }

    return $SlackExternalSelect
}