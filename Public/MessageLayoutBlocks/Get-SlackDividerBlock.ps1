function Get-SlackDividerBlock {
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