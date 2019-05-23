function Get-SlackContextBlock {
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