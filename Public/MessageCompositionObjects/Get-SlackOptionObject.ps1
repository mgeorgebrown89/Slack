function Get-SlackOptionObject {
    param(
        [ValidateLength(1,75)]
        [string]
        $text,

        [ValidateLength(1,75)]
        [string]
        $value
    )

    $SlackOption = [pscustomobject]@{
        text = @{
            type = "plain_text"
            text = $text
        }
        value = $value
    }
    return $SlackOption
}