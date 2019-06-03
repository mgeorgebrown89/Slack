function New-SlackImageBlock {
    <#
    .SYNOPSIS
        Returns a Slack Image Block.
    .DESCRIPTION
        This function returns a Slack Image Block as a PSCustom Object ready to ConvertTo-Json and send to Slack.
    .PARAMETER image_url
        The URL of the image to be displayed.
    .PARAMETER alt_text
        A plain-text summary of the image. This should not contain any markup.
    .PARAMETER title
        An optional title for the image in the form of a plain_text Text Object.
    .PARAMETER block_id
        Specifies the block_id of the Slack Block for reference by the Slack APIs.
    .LINK
        https://api.slack.com/reference/messaging/blocks#image
    .EXAMPLE
        New-SlackImageBlock -image_url "http://placekitten.com/500/500" -alt_text "Meow" -title "Cat"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1,3000)]
        [string]
        $image_url,
    
        [Parameter(Mandatory)]
        [ValidateLength(1,2000)]
        [string]
        $alt_text,
        
        [ValidateLength(1,2000)]
        [string]
        $title,
        
        [ValidateLength(1,255)]
        [string]
        $block_id
    )

    $SlackImageBlock = [pscustomobject]@{
        type = "image"
        image_url = $image_url
        alt_text = $alt_text
    }

    if($title){
        $SlackImageBlock | Add-Member -NotePropertyName "title" -NotePropertyValue @{
            type = "plain_text"
            text = $title
        }
    }
    if($block_id){
        $SlackImageBlock | Add-Member -NotePropertyName "block_id" -NotePropertyValue $block_id
    }

    return $SlackImageBlock
}