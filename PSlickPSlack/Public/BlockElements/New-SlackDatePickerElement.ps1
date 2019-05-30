function New-SlackDatePickerElement {
    param(
        [Parameter(Mandatory)]
        [ValidateLength(1,255)]
        $action_id,

        [ValidateLength(1,150)]
        [string]
        $placeholder,

        [datetime]
        $initial_date,

        [pscustomobject]
        $confirm
    )

    $SlackDatePicker = [pscustomobject]@{
        type = "datepicker"
        action_id = $action_id
        placholder = $placeholder
    }

    if($initial_date){
        $SlackDatePicker.initial_date = $initial_date
    }
    if($confirm){
        $SlackDatePicker.confirm = $confirm
    }

    return $SlackDatePicker
}