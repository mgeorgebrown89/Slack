function Send-SlackMeMessage{
    [CmdletBinding()]
    param(
        [string]
        $Token,

        [string]
        $Channel,

        [string]
        $Text
    )

    $Body = [PSCustomObject]@{
        channel = $Channel
        text = $Text
    }

    Invoke-SlackWebAPI -Token $Token -Method_Family "chat.meMessage" -Body $Body
}
Set-Alias -Name "chat.meMessage" -Value "Send-SlackMeMessage"