function New-SlackSectionBlock {
    <#
    .SYNOPSIS
        Returns a Slack Section Block PSCustomObject
    .DESCRIPTION
        This function returns a Slack Section Block as a PSCustomObject ready to ConvertTo-Json and send to Slack.
    .PARAMETER text
        The top level text of the Slack Block.
    .PARAMETER block_id
        Specifies the block_id of the Slack Block for reference by the Slack APIs.
    .PARAMETER fields
        An array of SlackTextObjects.
    .PARAMETER accessory
        A Slack Block element object
    .LINK
        https://api.slack.com/reference/messaging/blocks#section
    .EXAMPLE
        Get-SlackSectionBlock -text "The Text for this block." -block_id "123ABC"
    #>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1,3000)]
        [string]
        $text,

        [ValidateLength(1,255)]
        [string]
        $block_id,

        [ValidateCount(1,10)]
        [PSCustomObject[]]
        $fields,

        [pscustomobject]
        $accessory
    )

    $SlackSectionBlock = [pscustomobject]@{
        type = "section"
        text = @{
            type = "mrkdwn"
            text = $text
        }
    }
    if($block_id){
        $SlackSectionBlock | Add-Member -NotePropertyName "block_id" -NotePropertyValue $block_id
    }
    if($fields){
        $SlackSectionBlock | Add-Member -NotePropertyName "fields" -NotePropertyValue $fields
    }
    if($accessory){
        $SlackSectionBlock | Add-Member -NotePropertyName "accessory" -NotePropertyValue $accessory
    }

    return $SlackSectionBlock
}

