function New-SlackDatePickerElement {
    <#
    .SYNOPSIS
        Returns a Slack Date Picker.
    .DESCRIPTION
        This function returns a Slack Date Picker Element as a PSCustomObject ready to combine with other Slack Blocks,
        ConvertTo-Json, and send to Slack.
    .PARAMETER action_id
        An identifier for the action triggered when a menu option is selected.
    .PARAMETER placeholder
        Text that defines the placeholder text shown on the datepicker.
    .PARAMETER initial_date
        The initial date that is selected when the element is loaded. This should be in the format YYYY-MM-DD.
    .PARAMETER confirm
        A confirm object that defines an optional confirmation dialog that appears after a date is selected.
    .LINK
        https://api.slack.com/reference/messaging/block-elements#datepicker
    .EXAMPLE
        New-SlackDatePickerElement -action_id "date789" -placeholder "05/04/1971" -initial_date $dateTime
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1, 255)]
        $action_id,

        [ValidateLength(1, 150)]
        [string]
        $placeholder,

        [string] #add checks for datetime format. I tried but took too long.
        $initial_date,

        [pscustomobject]
        $confirm
    )

    $SlackDatePicker = [pscustomobject]@{
        type       = "datepicker"
        action_id  = $action_id
    }

    if($placeholder){
        $SlackDatePicker | Add-Member -NotePropertyName "placeholder" -NotePropertyValue $placeholder
    }
    if ($initial_date) {
        $SlackDatePicker | Add-Member -NotePropertyName "initial_date" -NotePropertyValue $initial_date
    }
    if ($confirm) {
        $SlackDatePicker | Add-Member -NotePropertyName "confirm" -NotePropertyValue $confirm
    }

    return $SlackDatePicker
}