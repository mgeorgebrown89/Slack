function New-SlackUserSelectMenuElement {
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1,150)]
        [string]
        $placeholder,
    
        [Parameter(Mandatory)]
        [ValidateLength(1,255)]
        [string]
        $action_id,

        [string]
        $initial_user,

        [pscustomobject]
        $confirm
    )

    $SlackUserSelect = [pscustomobject]@{
        type = "users_select"
        action_id = $action_id
        placeholder = @{
            type = "plain_text"
            text = $placeholder
        }
    }

    if($initial_user){
        $SlackUserSelect.initial_user = $initial_user
    }
    if($confirm){
        $SlackUserSelect.confirm = $confirm
    }

    return $SlackUserSelect
}