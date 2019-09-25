function New-SlackActionsBlock {
    <#
    .SYNOPSIS
        Returns a Slack Actions Block.
    .DESCRIPTION
        This function returns a Slack Actions Block as a PSCustom Object ready to ConvertTo-Json and send to Slack.
    .PARAMETER elements
        An array of interactive element objects - buttons, select menus, overflow menus, or date pickers. 
    .PARAMETER block_id
        Specifies the block_id of the Slack Block for reference by the Slack APIs.
    .LINK
        https://api.slack.com/reference/messaging/blocks#actions
    .EXAMPLE
        New-SlackActionsBlock -elements $elements -block_id "block45"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [pscustomobject[]]
        $elements,

        [string]
        $block_id
    )

    $SlackActionsBlock = [pscustomobject]@{
        type = "actions"
        elements = $elements
    }

    if($block_id){
        $SlackActionsBlock | Add-Member -NotePropertyName "block_id" -NotePropertyValue $block_id
    }

    return $SlackActionsBlock
}