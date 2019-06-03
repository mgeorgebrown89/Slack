function New-SlackContextBlock {
    <#
    .SYNOPSIS
        Returns a Slack Context Block.
    .DESCRIPTION
        This function returns a Slack Context Block as a PSCustom Object ready to ConvertTo-Json and send to Slack.
    .PARAMETER elements
        An array of image elements and text objects. 
    .PARAMETER block_id
        Specifies the block_id of the Slack Block for reference by the Slack APIs.
    .LINK
        https://api.slack.com/reference/messaging/blocks#context
    .EXAMPLE
        New-SlackContextBlock -elements $elements -block_id "block44"
    #>
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1,10)]
        [pscustomobject[]]
        $elements,

        [string]
        [ValidateLength(1,255)]
        $block_id
    )

    $SlackContextBlock = [pscustomobject]@{
        type = "context"
        elements = $elements
    }
    if($block_id){
        $SlackContextBlock | Add-Member -NotePropertyName "block_id" -NotePropertyValue $block_id
    }

    return $SlackContextBlock
}