function 0Get-SlackStaticSelectMenuElement {
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1,150)]
        [string]
        $placeholder,

        [Parameter(Mandatory)]
        [ValidateLength(1,255)]
        $action_id,

        [Parameter(Mandatory)]
        [ValidateLength(1,100)]
        [pscustomobject[]]
        $options,

        [Parameter(Mandatory)]
        [ValidateLength(1,100)]
        [pscustomobject[]]
        $option_groups,

        [pscustomobject]
        $initial_option,

        [pscustomobject]
        $confirm
    )

    $SlackStaticSelect = [pscustomobject]@{
        type = "static_select"
        action_id = $action_id
        placeholder = @{
            type = "plain_text"
            text = $placeholder
        }
    }

    if(!$option_groups -and $options){
        $SlackStaticSelect.options = $options
    }
    elseif (!$options -and $option_groups){
        $SlackStaticSelect.option_groups = $option_groups
    }
    else {
        Write-Error "You can't have both options and option groups in a Static Select Element."
    }

    if($initial_option){
        $SlackStaticSelect.initial_option = $initial_option
    }
    if($confirm){
        $SlackStaticSelect.confirm = $confirm
    }

    return $SlackStaticSelect
}