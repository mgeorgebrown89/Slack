function New-SlackExternalSelectMenuElement {
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1,150)]
        [string]
        $placeholder,

        [Parameter(Mandatory)]
        [ValidateLength(1,255)]
        [string]
        $action_id,

        [pscustomobject]
        $initial_option,

        [Int]
        $min_query_length,

        [pscustomobject]
        $confirm
    )

    $SlackExternalSelect = [pscustomobject]@{
        type = "external_select"
        action_id = $action_id
        placeholder = @{
            type = "plain_text"
            text = $placeholder
        }
    }

    return $SlackExternalSelect
}