function New-SlackUserSelectMenuElement {
    <#
    .SYNOPSIS
        Returns a Slack User Select Menu.
    .DESCRIPTION
        This function returns a Slack User Select Menu Element as a PSCustomObject ready to combine with other Slack Blocks,
        ConvertTo-Json, and send to Slack.
    .PARAMETER placeholder
        Text that defines the placeholder text shown on the menu.
    .PARAMETER action_id
        An identifier for the action triggered when a menu option is selected. 
    .PARAMETER initial_user
        The user ID of any valid user to be pre-selected when the menu loads.
    .PARAMETER confirm
        A confirm object that defines an optional confirmation dialog that appears after a menu item is selected.
    .LINK
        https://api.slack.com/reference/messaging/block-elements#users-select
    .EXAMPLE
        New-SlackUserSelectMenuElement -placeholder "Select a user" -action_id "selectedUser" -initial_user "U124567"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1,150)]
        [string]
        $placeholder,
    
        [Parameter(Mandatory)]
        [ValidateLength(1,255)]
        [string]
        $action_id,

        [string]
        $initial_user,

        [pscustomobject]
        $confirm
    )

    $SlackUserSelect = [pscustomobject]@{
        type = "users_select"
        action_id = $action_id
        placeholder = @{
            type = "plain_text"
            text = $placeholder
        }
    }

    if($initial_user){
        $SlackUserSelect.initial_user = $initial_user
    }
    if($confirm){
        $SlackUserSelect.confirm = $confirm
    }

    return $SlackUserSelect
}