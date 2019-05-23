function Get-SlackActionsBlock {
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