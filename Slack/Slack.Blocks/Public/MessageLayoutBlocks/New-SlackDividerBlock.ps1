function New-SlackDividerBlock {
        <#
    .SYNOPSIS
        Returns a Slack Divider Block PSCustomObject
    .DESCRIPTION
        This function returns a Slack Divider Block as a PSCustomObject ready to ConvertTo-Json and send to Slack.
    .PARAMETER block_id
        Specifies the block_id of the Slack Block for reference by the Slack APIs.
    .LINK
        https://api.slack.com/reference/messaging/blocks#divider
    .EXAMPLE
        Get-SlackDividerBlock -block_id "123ABC"
    #>
    [cmdletbinding()]
    param(
        [ValidateLength(1,255)]
        [string]
        $block_id
    )

    $SlackDivider = [pscustomobject]@{
        type = "divider"
    }
    if($block_id){
        $SlackDivider | Add-Member -NotePropertyName "block_id" -NotePropertyValue $block_id
    }
    
    return $SlackDivider
}