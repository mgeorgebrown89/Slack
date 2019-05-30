function New-SlackOptionGroupObject {
    param(
        [ValidateLength(1,75)]
        [string]
        $label,

        [ValidateLength(1,100)]
        [pscustomobject[]]
        $SlackOptions
    )
    $o = @()
    foreach($o in $SlackOptions){
        $option = @{
            text = @{
                type = "plain_text"
                text = $o.text
            }
            value = $o.value
        }
        $o += $option
    }

    $SlackOptionGroup = [pscustomobject]@{
        label = @{
            type = "plain_text"
            text = $label
        }
        options = $o
    }
    return $SlackOptionGroup
}