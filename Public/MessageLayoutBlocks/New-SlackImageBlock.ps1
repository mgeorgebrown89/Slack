function Get-SlackImageBlock {
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