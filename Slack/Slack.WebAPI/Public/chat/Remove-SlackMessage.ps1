
function Remove-SlackMessage {
    <#
    #>
    [CmdletBinding()]
    param (
        [string]
        [Parameter(Mandatory = $true)]
        $Token,

        [string]
        [Parameter(Mandatory = $true)]
        $ChannelId,

        [string]
        [Parameter(Mandatory = $true)]
        $Timestamp,

        [bool]
        $as_user = $true
    )

    $body = [PSCustomObject]@{
        channel = $ChannelId
        ts = $Timestamp
        as_user = $as_user
    }

    Invoke-SlackWebAPI -Token $token -Method_Family "chat.delete" -Body $body

}