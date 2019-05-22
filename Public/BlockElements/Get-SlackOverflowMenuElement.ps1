function Get-SlackOverflowMenuElement {
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1,255)]
        $action_id,

        [Parameter(Mandatory)]
        [ValidateLength(2,5)]
        [pscustomobject[]]
        $options,

        [pscustomobject]
        $confirm
    )

    $SlackOverflowMenu = [pscustomobject]@{
        type = "overflow"
        options = $options
    }

    if($confirm){
        $SlackOverflowMenu.confirm = $confirm
    }
    
    return $SlackOverflowMenu
}